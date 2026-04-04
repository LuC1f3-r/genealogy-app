import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// Data model for a family member node.
class PersonNode {
  const PersonNode({
    required this.id,
    required this.name,
    this.dob,
    this.dod,
    this.birthPlace,
    this.isLiving = false,
    this.photoUrl,
    this.gender = PersonGender.unknown,
    /// Pass a single spouse id here as convenience — converted to spouseIds.
    String? spouseId,
    this.spouseIds = const [],
    this.isSpouseOf,
    this.parentIds = const [],
    this.childIds = const [],
  }) : _spouseId = spouseId;

  final String id;
  final String name;
  final String? dob;
  final String? dod;
  final String? birthPlace;
  final bool isLiving;
  final String? photoUrl;
  final PersonGender gender;

  /// Set on a **wife** node to mark who she is married to.
  /// Her node will be positioned beside her husband rather than in the
  /// normal top-down spine.
  final String? isSpouseOf;

  /// All spouse IDs for this node (husband side).
  final List<String> spouseIds;
  final String? _spouseId;

  final List<String> parentIds;
  final List<String> childIds;

  /// All spouses (merges single spouseId + spouseIds list).
  List<String> get allSpouseIds {
    if (_spouseId != null && !spouseIds.contains(_spouseId)) {
      return [_spouseId, ...spouseIds];
    }
    return spouseIds;
  }

  String get lifespan {
    if (dob == null) return '';
    if (isLiving) return 'b. $dob';
    if (dod != null) return '$dob – $dod';
    return 'b. $dob';
  }

  int? get birthYear {
    if (dob == null) return null;
    final parts = dob!.split(' ');
    if (parts.length == 3) return int.tryParse(parts.last);
    return int.tryParse(dob!);
  }

  int? get deathYear {
    if (dod == null) return null;
    final parts = dod!.split(' ');
    if (parts.length == 3) return int.tryParse(parts.last);
    return int.tryParse(dod!);
  }
}

enum PersonGender { male, female, unknown }

// ─────────────────────────────────────────────────────────────────────────────

/// Heirloom profile card for a single family member.
///
/// Header bar colour = gender-tinted (steel-blue / dusty-rose).
/// Body shows Birth · Death · Birthplace rows.
class PersonCard extends StatefulWidget {
  const PersonCard({
    super.key,
    required this.person,
    this.onTap,
    this.isSelected = false,
    /// If true, draws a small crown/ring connector badge on the right edge
    /// indicating this node is a spouse.
    this.isSpouseCard = false,
  });

  final PersonNode person;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isSpouseCard;

  @override
  State<PersonCard> createState() => _PersonCardState();
}

class _PersonCardState extends State<PersonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  Color get _headerColor {
    switch (widget.person.gender) {
      case PersonGender.male:
        return const Color(0xFF7189A8);
      case PersonGender.female:
        return const Color(0xFFC17B8A);
      case PersonGender.unknown:
        return AppColors.primaryContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _scaleCtrl.forward(),
      onTapUp: (_) => _scaleCtrl.reverse(),
      onTapCancel: () => _scaleCtrl.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          width: 148,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(6),
            border: widget.isSelected
                ? Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.6),
                    width: 2,
                  )
                : Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.5),
                    width: 1,
                  ),
            boxShadow: [
              BoxShadow(
                color: AppColors.onSurface.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header bar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: _headerColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(5),
                  ),
                ),
                child: Text(
                  widget.person.name,
                  style: AppTextStyles.titleSm.copyWith(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Body — data rows
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DataRow(label: 'Birth', value: widget.person.dob ?? '—'),
                    const SizedBox(height: 4),
                    _DataRow(
                      label: 'Death',
                      value: widget.person.isLiving
                          ? 'Living'
                          : widget.person.dod ?? '—',
                      isDeceased:
                          !widget.person.isLiving && widget.person.dod != null,
                    ),
                    const SizedBox(height: 4),
                    _DataRow(
                        label: 'Place',
                        value: widget.person.birthPlace ?? '—'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.label,
    required this.value,
    this.isDeceased = false,
  });

  final String label;
  final String value;
  final bool isDeceased;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 36,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.outline,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDeceased ? AppColors.outline : AppColors.onSurface,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
