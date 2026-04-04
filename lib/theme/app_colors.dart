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

  // ── Relationship-type line colors ──────────────────────────────────────────
  /// Marriage connector — magenta heartline.
  static const Color marriage = Color(0xFFD6527A);

  /// Blood / parent-child — deep indigo-purple.
  static const Color bloodLine = Color(0xFF6C63FF);

  /// Adoptive child — muted slate (rendered dashed).
  static const Color adoptiveLine = Color(0xFF94A3B8);

  /// Divorced / break-up — warning red with X symbol.
  static const Color divorceLine = Color(0xFFEF4444);

  /// Heir connection — warm amber.
  static const Color heirLine = Color(0xFFF59E0B);

  /// Twins marker — teal accent.
  static const Color twinsMarker = Color(0xFF14B8A6);

  // ── Card gender tints ──────────────────────────────────────────────────────
  static const Color maleCardStart   = Color(0xFF3A6B8A);
  static const Color maleCardEnd     = Color(0xFF1E4A63);

  static const Color femaleCardStart = Color(0xFF8A4A68);
  static const Color femaleCardEnd   = Color(0xFF612843);

  static const Color neutralCard     = Color(0xFF4A5A4A);
}
