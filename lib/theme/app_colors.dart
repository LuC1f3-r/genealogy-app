import 'package:flutter/material.dart';

/// All color tokens from the Heirloom Digital Archive design system.
/// Never use Color(0xFF000000) — always use [AppColors.onSurface].
abstract final class AppColors {
  // ── Brand ──────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF183319);
  static const Color primaryContainer = Color(0xFF2E4A2E);
  static const Color primaryFixedDim = Color(0xFFAECFAA);
  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color secondary = Color(0xFF954556);
  static const Color secondaryFixed = Color(0xFFFFD9DE);
  static const Color onSecondary = Color(0xFFFFFFFF);

  static const Color tertiary = Color(0xFF603744);

  // ── Surface hierarchy (stacked papers) ────────────────────────────────
  /// Canvas — the base layer.
  static const Color surface = Color(0xFFFEF9EF);

  /// Main article / profile body blocks.
  static const Color surfaceContainer = Color(0xFFF2EDE3);

  /// Most elevated content cards.
  static const Color surfaceContainerHighest = Color(0xFFE7E2D8);

  /// Slightly lower than surfaceContainer — use under surfaceContainer cards.
  static const Color surfaceContainerLow = Color(0xFFF8F3E9);

  /// The neutral base used for the entire scaffold background.
  static const Color neutral = Color(0xFFF5F0E6);

  // ── Text / icons ───────────────────────────────────────────────────────
  /// Use instead of pure black for all text.
  static const Color onSurface = Color(0xFF1D1C16);

  // ── Outlines ───────────────────────────────────────────────────────────
  static const Color outline = Color(0xFF737970);

  /// Use at ≤15% opacity only. Full-opacity borders violate the system.
  static const Color outlineVariant = Color(0xFFC3C8BE);
}
