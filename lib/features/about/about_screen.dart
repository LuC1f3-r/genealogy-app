import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'widgets/curator_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Row(
          children: [
            const Icon(Icons.circle, color: AppColors.primary, size: 10),
            const SizedBox(width: 8),
            Text(
              'About This Family Tree',
              style: AppTextStyles.titleSm,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ── Hero — full-width photo with text overlay ─────────────────
          _HeroSection(),

          const SizedBox(height: 28),

          // ── Quote block ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '"This app is lovingly managed by the Janvekar family, rooted '
                'in Bijapur, Karnataka, India. It preserves our rich history '
                'across six generations… Built with care to keep memories '
                'alive for our children and grandchildren worldwide."',
                style: AppTextStyles.quoteBody,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // ── Rooted in History ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rooted in History', style: AppTextStyles.headlineSm),
                const SizedBox(height: 14),
                Text(
                  'From the historical heart of Karnataka to a global presence, '
                  'our journey is etched in the values passed down through the centuries.',
                  style: AppTextStyles.titleMd,
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // ── Curator card ───────────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CuratorCard(
              name: 'Managed by Ahmed Janvekar',
              role: 'Curator',
              subtitle: 'Hyderabad & global family representatives.',
            ),
          ),

          const SizedBox(height: 40),

          // ── Preserving the Essence image ───────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _EssenceImageBlock(),
          ),

          const SizedBox(height: 28),

          // ── Preserving the Essence body ────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Preserving the Essence', style: AppTextStyles.headlineSm),
                const SizedBox(height: 14),
                Text(
                  'We believe the family story is more than dates and names. '
                  'It is the texture of our lives—the photographs, the hand-written '
                  'letters, and the spoken memories that define who we are.',
                  style: AppTextStyles.titleMd,
                ),
              ],
            ),
          ),

          const SizedBox(height: 48),

          // ── Action icons ───────────────────────────────────────────────
          _ActionIcons(),

          const SizedBox(height: 40),

          // ── Footer ────────────────────────────────────────────────────
          _Footer(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero section — matches ref: full-width image with gradient + text overlay
// ─────────────────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background — sepia-toned placeholder
          Container(
            color: AppColors.surfaceContainerHighest,
            child: const _SepiaPerson(),
          ),

          // Gradient overlay (bottom-up) — text readable
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.surface.withValues(alpha: 0.85),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
          ),

          // Text — bottom-left
          Positioned(
            left: 24,
            bottom: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Our Family\nLegacy',
                  style: AppTextStyles.headlineMd.copyWith(
                    color: AppColors.primary,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ESTABLISHED IN BIJAPUR',
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.secondary,
                    letterSpacing: 2.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Sepia-toned silhouette placeholder that looks like an old family photo.
class _SepiaPerson extends StatelessWidget {
  const _SepiaPerson();

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix([
        // Sepia tone matrix
        0.393, 0.769, 0.189, 0, 0,
        0.349, 0.686, 0.168, 0, 0,
        0.272, 0.534, 0.131, 0, 0,
        0,     0,     0,     1, 0,
      ]),
      child: Container(
        color: AppColors.outlineVariant.withValues(alpha: 0.5),
        child: Center(
          child: Icon(
            Icons.person,
            size: 100,
            color: AppColors.outline.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Essence image — square dark photo (hands / prayer) — matches ref style
// ─────────────────────────────────────────────────────────────────────────────

class _EssenceImageBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: 160,
        width: double.infinity,
        color: AppColors.onSurface,
        child: Center(
          child: Icon(
            Icons.back_hand_outlined,
            size: 56,
            color: AppColors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action icons — mail + camera as circle icon buttons (ref style)
// ─────────────────────────────────────────────────────────────────────────────

class _ActionIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _IconCircle(icon: Icons.mail_outline, onTap: () {}),
        const SizedBox(width: 20),
        _IconCircle(icon: Icons.camera_alt_outlined, onTap: () {}),
      ],
    );
  }
}

class _IconCircle extends StatelessWidget {
  const _IconCircle({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.outlineVariant,
            width: 1.5,
          ),
        ),
        child: Icon(icon, size: 20, color: AppColors.onSurface),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Footer — matches ref: copyright, branding, bottom-nav labels
// ─────────────────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Divider(
            color: AppColors.outlineVariant.withValues(alpha: 0.5),
            thickness: 1,
          ),
        ),
        const SizedBox(height: 20),

        Text(
          '© 2026 JANVEKAR FAMILY',
          style: AppTextStyles.labelSm.copyWith(
            color: AppColors.outline,
            letterSpacing: 1.5,
          ),
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt, size: 14, color: AppColors.outline),
            const SizedBox(width: 4),
            Text(
              'KingpiN Vision Forge',
              style: AppTextStyles.labelSm.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'DIGITAL PRESERVATION PARTNER',
          style: AppTextStyles.labelSm.copyWith(
            color: AppColors.outline,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
