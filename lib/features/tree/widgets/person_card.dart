import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────

enum PersonGender { male, female, unknown }

/// How this person is connected to their parents in the tree.
enum ChildRelType { biological, adoptive, heir }

/// Data model for a family member node on the tree canvas.
class PersonNode {
  const PersonNode({
    required this.id,
    required this.name,
    this.dob,
    this.dod,
    this.currentLocation,
    this.isLiving = false,
    this.photoUrl,
    this.gender = PersonGender.unknown,
    this.childRelType = ChildRelType.biological,
    this.twinSiblingId,
    // spouse IDs (on the husband side)
    String? spouseId,
    this.spouseIds = const [],
    // set on a wife node to link back to the husband
    this.isSpouseOf,
    // set when this marriage ended in divorce (husband ID)
    this.divorcedFrom,
    this.parentIds = const [],
    this.childIds = const [],
  }) : _spouseId = spouseId;

  final String id;
  final String name;
  final String? dob;
  final String? dod;
  final String? currentLocation;
  final bool isLiving;
  final String? photoUrl;
  final PersonGender gender;
  final ChildRelType childRelType;

  /// If non-null, this node is rendered as a spouse card beside its husband.
  final String? isSpouseOf;

  /// If non-null, the marriage to this husband ended in divorce — renders
  /// a ✕ on the marriage connector.
  final String? divorcedFrom;

  /// ID of the twin sibling (for twin-pair markers).
  final String? twinSiblingId;

  final List<String> spouseIds;
  final String? _spouseId;
  final List<String> parentIds;
  final List<String> childIds;

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
    return int.tryParse(parts.last);
  }

  int? get deathYear {
    if (dod == null) return null;
    final parts = dod!.split(' ');
    return int.tryParse(parts.last);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Person Card Widget
// ─────────────────────────────────────────────────────────────────────────────

/// Portrait-style Heirloom card used on the family tree canvas.
///
/// Layout:
///   ┌─────────────────────┐
///   │  gradient header    │  ← gender tint + portrait silhouette
///   │       [photo]       │
///   ├─────────────────────┤
///   │  Name               │  ← Noto Serif, bold
///   │  1920 · 1998        │  ← small caps metadata
///   └─────────────────────┘
class PersonCard extends StatefulWidget {
  const PersonCard({
    super.key,
    required this.person,
    this.onTap,
    this.isSelected = false,
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
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  (Color, Color) get _gradientColors {
    switch (widget.person.gender) {
      case PersonGender.male:
        return (AppColors.maleCardStart, AppColors.maleCardEnd);
      case PersonGender.female:
        return (AppColors.femaleCardStart, AppColors.femaleCardEnd);
      case PersonGender.unknown:
        return (AppColors.neutralCard, AppColors.primaryContainer);
    }
  }

  IconData get _silhouetteIcon {
    switch (widget.person.gender) {
      case PersonGender.male:
        return Icons.person;
      case PersonGender.female:
        return Icons.person_2;
      case PersonGender.unknown:
        return Icons.person_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final (gradStart, gradEnd) = _gradientColors;
    final isSelected = widget.isSelected;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 120,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.onSurface.withValues(alpha: isSelected ? 0.18 : 0.10),
                blurRadius: isSelected ? 20 : 10,
                spreadRadius: isSelected ? 1 : 0,
                offset: const Offset(0, 4),
              ),
            ],
            border: isSelected
                ? Border.all(color: AppColors.marriage, width: 2)
                : Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.6),
                    width: 0.8,
                  ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Portrait area ───────────────────────────────────────────
                _PortraitArea(
                  gradStart: gradStart,
                  gradEnd: gradEnd,
                  icon: _silhouetteIcon,
                  person: widget.person,
                ),

                // ── Info area ───────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.person.name,
                        style: AppTextStyles.titleSm.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                          color: AppColors.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.person.lifespan.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          widget.person.lifespan,
                          style: AppTextStyles.labelSm.copyWith(
                            fontSize: 9,
                            color: AppColors.outline,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                      if (widget.person.currentLocation != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.person.currentLocation!,
                          style: AppTextStyles.labelSm.copyWith(
                            fontSize: 8,
                            color: AppColors.outline.withValues(alpha: 0.7),
                            letterSpacing: 0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PortraitArea extends StatelessWidget {
  const _PortraitArea({
    required this.gradStart,
    required this.gradEnd,
    required this.icon,
    required this.person,
  });

  final Color gradStart;
  final Color gradEnd;
  final IconData icon;
  final PersonNode person;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient background.
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [gradStart, gradEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Subtle pattern overlay (dot grid).
          CustomPaint(painter: _PortraitPatternPainter()),

          // Silhouette / avatar.
          Center(
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.15),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.35),
                  width: 1.5,
                ),
              ),
              child: Icon(
                icon,
                size: 30,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ),

          // Living indicator — small green dot top-right.
          if (person.isLiving)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF4ADE80),
                  border: Border.all(color: Colors.white, width: 1.2),
                ),
              ),
            ),

          // Adoptive badge — bottom-left.
          if (person.childRelType == ChildRelType.adoptive)
            const Positioned(
              bottom: 5,
              left: 6,
              child: _Badge(
                label: 'ADO',
                color: AppColors.adoptiveLine,
              ),
            ),

          // Heir badge — bottom-left.
          if (person.childRelType == ChildRelType.heir)
            const Positioned(
              bottom: 5,
              left: 6,
              child: _Badge(
                label: 'HEIR',
                color: AppColors.heirLine,
              ),
            ),

          // Twin badge — bottom-right.
          if (person.twinSiblingId != null)
            const Positioned(
              bottom: 5,
              right: 6,
              child: Icon(
                Icons.star_rounded,
                size: 13,
                color: AppColors.twinsMarker,
              ),
            ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 7,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Subtle dot pattern painted inside the portrait area for depth.
class _PortraitPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withValues(alpha: 0.06);
    for (double x = 8; x < size.width; x += 12) {
      for (double y = 8; y < size.height; y += 12) {
        canvas.drawCircle(Offset(x, y), 1.2, p);
      }
    }
  }

  @override
  bool shouldRepaint(_PortraitPatternPainter _) => false;
}
