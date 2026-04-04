import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// App-wide bottom navigation bar with Tree and About tabs.
///
/// Uses surface-tier separation (no border) to float above the canvas.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        // Ambient shadow — no hard border.
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _NavItem(
                index: 0,
                currentIndex: currentIndex,
                onTap: onTap,
                icon: Icons.account_tree_outlined,
                activeIcon: Icons.account_tree,
                label: 'TREE',
              ),
              _NavItem(
                index: 1,
                currentIndex: currentIndex,
                onTap: onTap,
                icon: Icons.info_outline,
                activeIcon: Icons.info,
                label: 'ABOUT',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.onTap,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final IconData icon;
  final IconData activeIcon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    final color = isActive ? AppColors.primary : AppColors.outline;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: SizedBox(
          height: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: color,
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTextStyles.labelSm.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
