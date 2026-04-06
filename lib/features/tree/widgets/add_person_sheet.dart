import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../data/repositories/family_tree_repository.dart';
import '../../../features/auth/auth_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import 'person_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Public entry-point
// ─────────────────────────────────────────────────────────────────────────────

/// Opens the "Add family member" bottom sheet.
///
/// [nodes] is the current live list from Firestore, used to populate the
/// relationship dropdowns without an extra network round-trip.
Future<void> showAddPersonSheet(
  BuildContext context,
  List<PersonNode> nodes,
) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => AddPersonSheet(nodes: nodes),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Sheet widget
// ─────────────────────────────────────────────────────────────────────────────

class AddPersonSheet extends ConsumerStatefulWidget {
  const AddPersonSheet({super.key, required this.nodes});

  /// All persons currently in the tree — used to populate dropdown menus.
  final List<PersonNode> nodes;

  @override
  ConsumerState<AddPersonSheet> createState() => _AddPersonSheetState();
}

class _AddPersonSheetState extends ConsumerState<AddPersonSheet> {
  final _formKey = GlobalKey<FormState>();

  // ── Identity fields ────────────────────────────────────────────────────────
  final _nameCtr      = TextEditingController();
  final _dobCtr       = TextEditingController();
  final _dodCtr       = TextEditingController();
  final _placeCtr     = TextEditingController();

  PersonGender  _gender   = PersonGender.unknown;
  bool          _isLiving = true;
  ChildRelType  _relType  = ChildRelType.biological;

  // ── Relationship links ─────────────────────────────────────────────────────
  String? _fatherId;
  String? _motherId;
  String? _husbandId; // only relevant when _gender == female

  // ── Submission state ───────────────────────────────────────────────────────
  bool _saving = false;

  // ── Convenience getters ────────────────────────────────────────────────────
  List<PersonNode> get _males =>
      widget.nodes.where((n) => n.gender == PersonGender.male).toList();

  List<PersonNode> get _females =>
      widget.nodes.where((n) => n.gender == PersonGender.female).toList();

  List<PersonNode> get _any => widget.nodes;

  bool get _hasParent => _fatherId != null || _motherId != null;

  @override
  void dispose() {
    _nameCtr.dispose();
    _dobCtr.dispose();
    _dodCtr.dispose();
    _placeCtr.dispose();
    super.dispose();
  }

  // ── Submit ─────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _saving = true);

    try {
      final newId = const Uuid().v4();

      final person = PersonNode(
        id:           newId,
        name:         _nameCtr.text.trim(),
        gender:       _gender,
        isLiving:     _isLiving,
        dob:          _dobCtr.text.trim().isEmpty ? null : _dobCtr.text.trim(),
        dod:          (!_isLiving && _dodCtr.text.trim().isNotEmpty)
                          ? _dodCtr.text.trim()
                          : null,
        currentLocation:   _placeCtr.text.trim().isEmpty ? null : _placeCtr.text.trim(),
        childRelType: _hasParent ? _relType : ChildRelType.biological,
        isSpouseOf:   _husbandId,
        parentIds: [
          if (_fatherId != null) _fatherId!,
          if (_motherId != null) _motherId!,
        ],
      );

      final repo = ref.read(familyTreeRepositoryProvider);
      await repo.addPerson(
        kTreeId,
        person,
        fatherIdToUpdate:  _fatherId,
        motherIdToUpdate:  _motherId,
        husbandIdToUpdate: _husbandId,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${person.name} added to the tree'),
            backgroundColor: AppColors.primaryContainer,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not save: $e'),
            backgroundColor: AppColors.divorceLine,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize:     0.60,
      maxChildSize:     0.97,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 40,
                offset: Offset(0, -8),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              controller: controller,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 24 + bottom),
              children: [
                // ── Handle ──────────────────────────────────────────────────
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 4),
                    child: Container(
                      width: 36, height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.outlineVariant.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),

                // ── Header ──────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text('Add Family Member',
                      style: AppTextStyles.headlineSm),
                ),

                _SectionLabel('IDENTITY'),
                const SizedBox(height: 12),

                // ── Name ────────────────────────────────────────────────────
                TextFormField(
                  controller: _nameCtr,
                  style: AppTextStyles.titleMd,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDeco('Full name *'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 20),

                // ── Gender ──────────────────────────────────────────────────
                _FieldLabel('Gender'),
                const SizedBox(height: 8),
                SegmentedButton<PersonGender>(
                  selected: {_gender},
                  onSelectionChanged: (s) => setState(() {
                    _gender = s.first;
                    // Reset husband link if gender changed away from female
                    if (_gender != PersonGender.female) _husbandId = null;
                  }),
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: AppColors.primary,
                    selectedForegroundColor: AppColors.onPrimary,
                    foregroundColor: AppColors.outline,
                    side: const BorderSide(
                        color: AppColors.outlineVariant),
                  ),
                  segments: const [
                    ButtonSegment(
                      value: PersonGender.male,
                      label: Text('Male'),
                      icon: Icon(Icons.person),
                    ),
                    ButtonSegment(
                      value: PersonGender.female,
                      label: Text('Female'),
                      icon: Icon(Icons.person_2),
                    ),
                    ButtonSegment(
                      value: PersonGender.unknown,
                      label: Text('Unknown'),
                      icon: Icon(Icons.person_outline),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Is Living ───────────────────────────────────────────────
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Currently living', style: AppTextStyles.titleSm),
                  value: _isLiving,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _isLiving = v),
                ),
                const SizedBox(height: 4),

                // ── DOB ─────────────────────────────────────────────────────
                TextFormField(
                  controller: _dobCtr,
                  style: AppTextStyles.titleMd,
                  keyboardType: TextInputType.datetime,
                  decoration: _inputDeco('Date of birth  (YYYY-MM-DD)'),
                ),
                const SizedBox(height: 20),

                // ── DOD (only when not living) ───────────────────────────────
                if (!_isLiving) ...[
                  TextFormField(
                    controller: _dodCtr,
                    style: AppTextStyles.titleMd,
                    keyboardType: TextInputType.datetime,
                    decoration: _inputDeco('Date of death  (YYYY-MM-DD)'),
                  ),
                  const SizedBox(height: 20),
                ],

                // ── Birth place ──────────────────────────────────────────────
                TextFormField(
                  controller: _placeCtr,
                  style: AppTextStyles.titleMd,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDeco('Birth place'),
                ),
                const SizedBox(height: 28),

                // ── Family links ─────────────────────────────────────────────
                _SectionLabel('FAMILY LINKS'),
                const SizedBox(height: 12),

                // Father dropdown
                _PersonDropdown(
                  label: 'Father',
                  hint: 'Select father',
                  persons: _males,
                  value: _fatherId,
                  onChanged: (v) => setState(() => _fatherId = v),
                ),
                const SizedBox(height: 16),

                // Mother dropdown (any gender — blended/adoptive families)
                _PersonDropdown(
                  label: 'Mother',
                  hint: 'Select mother',
                  persons: _any,
                  value: _motherId,
                  onChanged: (v) => setState(() => _motherId = v),
                ),
                const SizedBox(height: 16),

                // Husband dropdown — only for female persons
                if (_gender == PersonGender.female) ...[
                  _PersonDropdown(
                    label: 'Husband',
                    hint: 'Select husband',
                    persons: _males,
                    value: _husbandId,
                    onChanged: (v) => setState(() => _husbandId = v),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Child relationship type (shown only if a parent is set) ──
                if (_hasParent) ...[
                  const SizedBox(height: 12),
                  _SectionLabel('RELATIONSHIP TO PARENTS'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    children: ChildRelType.values.map((type) {
                      final label = switch (type) {
                        ChildRelType.biological => 'Biological',
                        ChildRelType.adoptive   => 'Adoptive',
                        ChildRelType.heir       => 'Heir',
                      };
                      final color = switch (type) {
                        ChildRelType.adoptive => AppColors.adoptiveLine,
                        ChildRelType.heir     => AppColors.heirLine,
                        _                    => AppColors.primary,
                      };
                      return ChoiceChip(
                        label: Text(label),
                        selected: _relType == type,
                        onSelected: (_) => setState(() => _relType = type),
                        selectedColor: color.withValues(alpha: 0.18),
                        labelStyle: AppTextStyles.labelMd.copyWith(
                          color: _relType == type ? color : AppColors.outline,
                          fontWeight: _relType == type
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                        side: BorderSide(
                          color: _relType == type
                              ? color
                              : AppColors.outlineVariant,
                        ),
                        backgroundColor: AppColors.surface,
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                ],

                const SizedBox(height: 32),

                // ── Action buttons ───────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _saving
                            ? null
                            : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: AppColors.outline),
                          foregroundColor: AppColors.outline,
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _saving ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          disabledBackgroundColor:
                              AppColors.primary.withValues(alpha: 0.5),
                        ),
                        child: _saving
                            ? const SizedBox(
                                width: 20, height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.onPrimary,
                                ),
                              )
                            : const Text('Add to Tree'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  InputDecoration _inputDeco(String label) => InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.titleSm.copyWith(color: AppColors.outline),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.divorceLine),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.divorceLine, width: 2),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Small helper widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: AppTextStyles.labelSm.copyWith(
          color: AppColors.outline,
          letterSpacing: 1.4,
        ),
      );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: AppTextStyles.titleSm.copyWith(color: AppColors.outline),
      );
}

/// Dropdown that shows a nullable list of persons.
class _PersonDropdown extends StatelessWidget {
  const _PersonDropdown({
    required this.label,
    required this.hint,
    required this.persons,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final List<PersonNode> persons;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String?>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.titleSm.copyWith(color: AppColors.outline),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      hint: Text(hint,
          style: AppTextStyles.titleSm.copyWith(color: AppColors.outline)),
      style: AppTextStyles.titleMd,
      dropdownColor: AppColors.surfaceContainer,
      items: [
        // "None" option to clear the selection
        DropdownMenuItem<String?>(
          value: null,
          child: Text('— None —',
              style:
                  AppTextStyles.titleSm.copyWith(color: AppColors.outline)),
        ),
        ...persons.map(
          (p) => DropdownMenuItem<String?>(
            value: p.id,
            child: Text(p.name, style: AppTextStyles.titleMd),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
