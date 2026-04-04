import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'widgets/family_tree_canvas.dart';
import 'widgets/person_card.dart';

/// Seed data — replace with your data layer.
final _sampleNodes = [
  // Generation 0: Abdul + two wives
  const PersonNode(
    id: 'root',
    name: 'Abdul Janvekar',
    dob: '1 Jan 1890',
    dod: '14 Aug 1965',
    birthPlace: 'Bijapur, Karnataka',
    gender: PersonGender.male,
    spouseIds: ['wife1', 'wife2'],
  ),
  const PersonNode(
    id: 'wife1',
    name: 'Amina Begum',
    dob: '3 Mar 1895',
    dod: '20 Nov 1970',
    birthPlace: 'Bijapur, Karnataka',
    gender: PersonGender.female,
    isSpouseOf: 'root',
    childIds: ['s1', 's2'],
  ),
  const PersonNode(
    id: 'wife2',
    name: 'Khadija Sultana',
    dob: '10 Jun 1900',
    dod: '1 Apr 1975',
    birthPlace: 'Sholapur, Maharashtra',
    gender: PersonGender.female,
    isSpouseOf: 'root',
    childIds: ['s3', 's4'],
  ),
  // Generation 1: Children of Amina (wife1)
  const PersonNode(
    id: 's1',
    name: 'Hamid Janvekar',
    dob: '10 Apr 1920',
    dod: '5 Feb 1998',
    birthPlace: 'Bijapur, Karnataka',
    gender: PersonGender.male,
    parentIds: ['root', 'wife1'],
    spouseIds: ['s1_w'],
  ),
  const PersonNode(
    id: 's1_w',
    name: 'Rukhsar Begum',
    dob: '5 Dec 1923',
    dod: '12 Sep 2001',
    birthPlace: 'Gulbarga, Karnataka',
    gender: PersonGender.female,
    isSpouseOf: 's1',
    childIds: ['g1', 'g2'],
  ),
  const PersonNode(
    id: 's2',
    name: 'Fatima Janvekar',
    dob: '22 Jul 1925',
    dod: '9 Dec 2002',
    birthPlace: 'Bijapur, Karnataka',
    gender: PersonGender.female,
    parentIds: ['root', 'wife1'],
  ),
  // Generation 1: Children of Khadija (wife2)
  const PersonNode(
    id: 's3',
    name: 'Yusuf Janvekar',
    dob: '18 Mar 1928',
    birthPlace: 'Sholapur, Maharashtra',
    isLiving: true,
    gender: PersonGender.male,
    parentIds: ['root', 'wife2'],
    spouseIds: ['s3_w'],
  ),
  const PersonNode(
    id: 's3_w',
    name: 'Noorjahan Shaikh',
    dob: '2 Aug 1932',
    birthPlace: 'Pune, Maharashtra',
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
    birthPlace: 'Sholapur, Maharashtra',
    gender: PersonGender.female,
    parentIds: ['root', 'wife2'],
  ),
  // Generation 2: Children of Hamid+Rukhsar
  const PersonNode(
    id: 'g1',
    name: 'Ahmed Janvekar',
    dob: '14 Feb 1955',
    birthPlace: 'Bijapur, Karnataka',
    isLiving: true,
    gender: PersonGender.male,
    parentIds: ['s1', 's1_w'],
    spouseIds: ['g1_w'],
  ),
  const PersonNode(
    id: 'g1_w',
    name: 'Sana Khan',
    dob: '20 May 1958',
    birthPlace: 'Hyderabad, Telangana',
    isLiving: true,
    gender: PersonGender.female,
    isSpouseOf: 'g1',
    childIds: ['gg1', 'gg2'],
  ),
  const PersonNode(
    id: 'g2',
    name: 'Razia Janvekar',
    dob: '8 Sep 1958',
    birthPlace: 'Bijapur, Karnataka',
    isLiving: true,
    gender: PersonGender.female,
    parentIds: ['s1', 's1_w'],
  ),
  // Generation 2: Children of Yusuf+Noorjahan
  const PersonNode(
    id: 'g3',
    name: 'Imran Janvekar',
    dob: '30 Oct 1962',
    birthPlace: 'Hubli, Karnataka',
    isLiving: true,
    gender: PersonGender.male,
    parentIds: ['s3', 's3_w'],
  ),
  const PersonNode(
    id: 'g4',
    name: 'Zainab Shaikh',
    dob: '17 Jun 1965',
    birthPlace: 'Pune, Maharashtra',
    isLiving: true,
    gender: PersonGender.female,
    parentIds: ['s3', 's3_w'],
  ),
  // Generation 3: Children of Ahmed+Sana
  const PersonNode(
    id: 'gg1',
    name: 'Sara Janvekar',
    dob: '3 May 1985',
    birthPlace: 'Hyderabad, Telangana',
    isLiving: true,
    gender: PersonGender.female,
    parentIds: ['g1', 'g1_w'],
  ),
  const PersonNode(
    id: 'gg2',
    name: 'Zaid Janvekar',
    dob: '11 Nov 1988',
    birthPlace: 'Hyderabad, Telangana',
    isLiving: true,
    gender: PersonGender.male,
    parentIds: ['g1', 'g1_w'],
  ),
];

class TreeScreen extends StatefulWidget {
  const TreeScreen({super.key});

  @override
  State<TreeScreen> createState() => _TreeScreenState();
}

class _TreeScreenState extends State<TreeScreen> {

  void _onPersonTap(PersonNode person) {
    _showPersonSheet(person);
  }

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
        title: const Row(
          children: [
            Icon(Icons.shield, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('The Janvekar Family Tree'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            iconSize: 24,
            tooltip: 'Search',
            onPressed: () {},
          ),
        ],
      ),
      body: FamilyTreeCanvas(
        nodes: _sampleNodes,
        onPersonTap: _onPersonTap,
      ),
    );
  }
}

/// Bottom sheet showing a person's details.
class _PersonDetailSheet extends StatelessWidget {
  const _PersonDetailSheet({required this.person});

  final PersonNode person;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: AppColors.onSurface.withValues(alpha: 0.06),
                blurRadius: 40,
                offset: const Offset(0, -12),
              ),
            ],
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            children: [
              // Drag handle.
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(person.name, style: AppTextStyles.headlineSm),
              if (person.lifespan.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  person.lifespan.toUpperCase(),
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              Text('Life Events', style: AppTextStyles.titleSm),
              const SizedBox(height: 16),
              _LifeEventRow(
                value: person.dob ?? '—',
                label: 'BORN',
                color: AppColors.secondary,
              ),
              if (person.dod != null) ...[
                _LifeEventRow(
                  value: person.dod!,
                  label: 'DIED',
                  color: AppColors.outline,
                ),
              ],
              if (person.birthPlace != null) ...[
                _LifeEventRow(
                  value: person.birthPlace!,
                  label: 'BIRTHPLACE',
                  color: AppColors.primary,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _LifeEventRow extends StatelessWidget {
  const _LifeEventRow({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 2,
            height: 40,
            margin: const EdgeInsets.only(right: 16),
            color: color.withValues(alpha: 0.5),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.labelSm.copyWith(color: color),
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
