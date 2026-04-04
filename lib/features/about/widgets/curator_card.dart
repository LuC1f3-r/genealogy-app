import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// Curator info card — elevated surface, left-edge secondary accent.
/// No border; depth via `surfaceContainerHighest` on `surfaceContainer`.
class CuratorCard extends StatelessWidget {
  const CuratorCard({
    super.key,
    required this.name,
    required this.role,
    this.subtitle,
  });

  final String name;
  final String role;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left accent bar — the only place secondary maroon appears.
            Container(
              width: 3,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(8),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role.toUpperCase(),
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.outline,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(name, style: AppTextStyles.headlineSm),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: AppTextStyles.titleMd.copyWith(
                          color: AppColors.outline,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
