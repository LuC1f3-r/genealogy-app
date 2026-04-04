import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'widgets/family_tree_canvas.dart';
import 'widgets/person_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Sample data — showcases all relationship types
// ─────────────────────────────────────────────────────────────────────────────
//
// Tree structure (6 generations):
//
//   Gen 0:  Abdul Janvekar
//             ├─♥─ Amina Begum   (wife 1 → sons: Hamid, Fatima)
//             └─♥─ Khadija       (wife 2 → sons: Yusuf, Maryam)
//
//   Gen 1:  Hamid ──♥── Rukhsar  → Ahmed, Razia
//           Yusuf ──♥── Noorjahan → Imran, Zainab
//           Maryam (no spouse in dataset)
//
//   Gen 2:  Ahmed ──♥── Sana → Sara, Zaid (twins)
//           Imran ──♥── Layla → Farah (adoptive), Bilal (heir)
//
//   Gen 3:  Zaid ──✕── Priya (divorced)
//           Zaid ──♥── Hana  → Omar
//
final _sampleNodes = <PersonNode>[

  // ── Generation 0 ───────────────────────────────────────────────────────
  const PersonNode(
    id: 'root',
    name: 'Abdul Janvekar',
    dob: '1 Jan 1890',
    dod: '14 Aug 1965',
    birthPlace: 'Bijapur, KA',
    gender: PersonGender.male,
    spouseIds: ['wife1', 'wife2'],
  ),

  // Wife 1 — children: s1 (Hamid), s2 (Fatima)
  const PersonNode(
    id: 'wife1',
    name: 'Amina Begum',
    dob: '3 Mar 1895',
    dod: '20 Nov 1970',
    birthPlace: 'Bijapur, KA',
    gender: PersonGender.female,
    isSpouseOf: 'root',
    childIds: ['s1', 's2'],
  ),

  // Wife 2 — children: s3 (Yusuf), s4 (Maryam)
  const PersonNode(
    id: 'wife2',
    name: 'Khadija Sultana',
    dob: '10 Jun 1900',
    dod: '1 Apr 1975',
    birthPlace: 'Sholapur, MH',
    gender: PersonGender.female,
    isSpouseOf: 'root',
    childIds: ['s3', 's4'],
  ),

  // ── Generation 1 ───────────────────────────────────────────────────────
  const PersonNode(
    id: 's1',
    name: 'Hamid Janvekar',
    dob: '10 Apr 1920',
    dod: '5 Feb 1998',
    birthPlace: 'Bijapur, KA',
    gender: PersonGender.male,
    parentIds: ['root', 'wife1'],
    spouseIds: ['s1w'],
  ),

  const PersonNode(
    id: 's1w',
    name: 'Rukhsar Begum',
    dob: '5 Dec 1923',
    dod: '12 Sep 2001',
    birthPlace: 'Gulbarga, KA',
    gender: PersonGender.female,
    isSpouseOf: 's1',
    childIds: ['g1', 'g2'],
  ),

  const PersonNode(
    id: 's2',
    name: 'Fatima Janvekar',
    dob: '22 Jul 1925',
    dod: '9 Dec 2002',
    birthPlace: 'Bijapur, KA',
    gender: PersonGender.female,
    parentIds: ['root', 'wife1'],
  ),

  const PersonNode(
    id: 's3',
    name: 'Yusuf Janvekar',
    dob: '18 Mar 1928',
    birthPlace: 'Sholapur, MH',
    isLiving: true,
    gender: PersonGender.male,
    parentIds: ['root', 'wife2'],
    spouseIds: ['s3w'],
  ),

  const PersonNode(
    id: 's3w',
    name: 'Noorjahan Shaikh',
    dob: '2 Aug 1932',
    birthPlace: 'Pune, MH',
    isLiving: true,
    gender: PersonGender.female,
    isSpouseOf: 's3',
    childIds: ['g3', 'g4'],
  ),

  const PersonNode(
    id: 's4',
    name: 'Maryam Malik',
    dob: '30 Nov 1933',
    dod: '7 Feb 2010',
    birthPlace: 'Sholapur, MH',
    gender: PersonGender.female,
    parentIds: ['root', 'wife2'],
  ),

  // ── Generation 2 ───────────────────────────────────────────────────────
  const PersonNode(
    id: 'g1',
    name: 'Ahmed Janvekar',
    dob: '14 Feb 1955',
    birthPlace: 'Bijapur, KA',
    isLiving: true,
    gender: PersonGender.male,
    parentIds: ['s1', 's1w'],
    spouseIds: ['g1w'],
  ),

  const PersonNode(
    id: 'g1w',
    name: 'Sana Khan',
    dob: '20 May 1958',
    birthPlace: 'Hyderabad, TG',
    isLiving: true,
    gender: PersonGender.female,
    isSpouseOf: 'g1',
    // Sara & Zaid are twins — note twinSiblingId on each
    childIds: ['gg1', 'gg2'],
  ),

  const PersonNode(
    id: 'g2',
    name: 'Razia Janvekar',
    dob: '8 Sep 1958',
    birthPlace: 'Bijapur, KA',
    isLiving: true,
    gender: PersonGender.female,
    parentIds: ['s1', 's1w'],
  ),

  // Imran has one biological child (Bilal, heir) and one adoptive child (Farah).
  const PersonNode(
    id: 'g3',
    name: 'Imran Janvekar',
    dob: '30 Oct 1962',
    birthPlace: 'Hubli, KA',
    isLiving: true,
    gender: PersonGender.male,
    parentIds: ['s3', 's3w'],
    spouseIds: ['g3w'],
  ),

  const PersonNode(
    id: 'g3w',
    name: 'Layla Hussain',
    dob: '14 Jan 1966',
    birthPlace: 'Bengaluru, KA',
    isLiving: true,
    gender: PersonGender.female,
    isSpouseOf: 'g3',
    childIds: ['gg3', 'gg4'],
  ),

  const PersonNode(
    id: 'g4',
    name: 'Zainab Shaikh',
    dob: '17 Jun 1965',
    birthPlace: 'Pune, MH',
    isLiving: true,
    gender: PersonGender.female,
    parentIds: ['s3', 's3w'],
  ),

  // ── Generation 3 ───────────────────────────────────────────────────────

  // Sara & Zaid — twins (mark twinSiblingId on each).
  const PersonNode(
    id: 'gg1',
    name: 'Sara Janvekar',
    dob: '3 May 1985',
    birthPlace: 'Hyderabad, TG',
    isLiving: true,
    gender: PersonGender.female,
    parentIds: ['g1', 'g1w'],
    twinSiblingId: 'gg2',
  ),

  // Zaid: first wife divorced, second wife current.
  const PersonNode(
    id: 'gg2',
    name: 'Zaid Janvekar',
    dob: '3 May 1985',
    birthPlace: 'Hyderabad, TG',
    isLiving: true,
    gender: PersonGender.male,
    parentIds: ['g1', 'g1w'],
    twinSiblingId: 'gg1',
    spouseIds: ['gg2w1', 'gg2w2'],
  ),

  // Zaid's first wife — divorced.
  const PersonNode(
    id: 'gg2w1',
    name: 'Priya Sharma',
    dob: '10 Jul 1986',
    birthPlace: 'Chennai, TN',
    isLiving: true,
    gender: PersonGender.female,
    isSpouseOf: 'gg2',
    divorcedFrom: 'gg2',  // signals divorce X on the connector
  ),

  // Zaid's second wife — current.
  const PersonNode(
    id: 'gg2w2',
    name: 'Hana Al-Rashid',
    dob: '5 Mar 1988',
    birthPlace: 'Dubai, UAE',
    isLiving: true,
    gender: PersonGender.female,
    isSpouseOf: 'gg2',
    childIds: ['gg2c1'],
  ),

  // Zaid & Hana's son.
  const PersonNode(
    id: 'gg2c1',
    name: 'Omar Janvekar',
    dob: '22 Jun 2012',
    birthPlace: 'Hyderabad, TG',
    isLiving: true,
    gender: PersonGender.male,
    parentIds: ['gg2', 'gg2w2'],
  ),

  // Farah — adoptive child of Imran.
  const PersonNode(
    id: 'gg3',
    name: 'Farah Hussain',
    dob: '8 Sep 1993',
    birthPlace: 'Bengaluru, KA',
    isLiving: true,
    gender: PersonGender.female,
    parentIds: ['g3', 'g3w'],
    childRelType: ChildRelType.adoptive,
  ),

  // Bilal — heir of Imran.
  const PersonNode(
    id: 'gg4',
    name: 'Bilal Janvekar',
    dob: '30 Dec 1996',
    birthPlace: 'Bengaluru, KA',
    isLiving: true,
    gender: PersonGender.male,
    parentIds: ['g3', 'g3w'],
    childRelType: ChildRelType.heir,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Tree Screen
// ─────────────────────────────────────────────────────────────────────────────

class TreeScreen extends StatefulWidget {
  const TreeScreen({super.key});

  @override
  State<TreeScreen> createState() => _TreeScreenState();
}

class _TreeScreenState extends State<TreeScreen> {

  void _onPersonTap(PersonNode person) => _showPersonSheet(person);

  void _showPersonSheet(PersonNode person) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _PersonDetailSheet(person: person),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Row(
          children: [
            Icon(Icons.shield, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('The Janvekar Family Tree'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            tooltip: 'More options',
            onPressed: () {},
          ),
        ],
      ),
      body: FamilyTreeCanvas(
        nodes: _sampleNodes,
        onPersonTap: _onPersonTap,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add person',
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Person detail bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class _PersonDetailSheet extends StatelessWidget {
  const _PersonDetailSheet({required this.person});
  final PersonNode person;

  (Color, Color) get _gradColors {
    switch (person.gender) {
      case PersonGender.male:
        return (AppColors.maleCardStart, AppColors.maleCardEnd);
      case PersonGender.female:
        return (AppColors.femaleCardStart, AppColors.femaleCardEnd);
      case PersonGender.unknown:
        return (AppColors.neutralCard, AppColors.primaryContainer);
    }
  }

  IconData get _genderIcon {
    switch (person.gender) {
      case PersonGender.male:   return Icons.person;
      case PersonGender.female: return Icons.person_2;
      case PersonGender.unknown: return Icons.person_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final (gradStart, gradEnd) = _gradColors;

    return DraggableScrollableSheet(
      initialChildSize: 0.52,
      minChildSize: 0.32,
      maxChildSize: 0.90,
      builder: (_, controller) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.onSurface.withValues(alpha: 0.10),
                    blurRadius: 40,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: ListView(
                controller: controller,
                padding: EdgeInsets.zero,
                children: [
                  // ── Sheet handle ────────────────────────────────────────
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 0),
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.outlineVariant.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),

                  // ── Portrait hero ───────────────────────────────────────
                  Container(
                    height: 120,
                    margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    decoration: BoxDecoration(
                      gradient:
                          LinearGradient(colors: [gradStart, gradEnd]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.15),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.4),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              _genderIcon,
                              size: 40,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                        if (person.isLiving)
                          Positioned(
                            top: 12,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color:
                                    Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.circle,
                                      size: 6,
                                      color: Color(0xFF4ADE80)),
                                  SizedBox(width: 4),
                                  Text(
                                    'Living',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // ── Name + metadata ─────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(person.name, style: AppTextStyles.headlineSm),
                        if (person.birthPlace != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            person.birthPlace!,
                            style: AppTextStyles.titleMd.copyWith(
                              color: AppColors.outline,
                              fontSize: 14,
                            ),
                          ),
                        ],
                        if (person.childRelType != ChildRelType.biological) ...[
                          const SizedBox(height: 8),
                          _RelTypePill(type: person.childRelType),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Life events ──────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Life Events',
                        style: AppTextStyles.titleSm.copyWith(
                            color: AppColors.outline, fontSize: 11,
                            letterSpacing: 1.4)),
                  ),
                  const SizedBox(height: 12),

                  if (person.dob != null)
                    _EventRow(
                      label: 'BORN',
                      value: person.dob!,
                      color: AppColors.marriage,
                    ),
                  if (!person.isLiving && person.dod != null)
                    _EventRow(
                      label: 'DIED',
                      value: person.dod!,
                      color: AppColors.outline,
                    ),
                  if (person.birthPlace != null)
                    _EventRow(
                      label: 'BIRTHPLACE',
                      value: person.birthPlace!,
                      color: AppColors.primary,
                    ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RelTypePill extends StatelessWidget {
  const _RelTypePill({required this.type});
  final ChildRelType type;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (type) {
      ChildRelType.adoptive => ('ADOPTIVE', AppColors.adoptiveLine),
      ChildRelType.heir     => ('HEIR', AppColors.heirLine),
      _                     => ('', Colors.transparent),
    };
    if (label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3,
            height: 40,
            margin: const EdgeInsets.only(right: 14, top: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.labelSm.copyWith(
                  color: color,
                  fontSize: 10,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.titleMd),
            ],
          ),
        ],
      ),
    );
  }
}
