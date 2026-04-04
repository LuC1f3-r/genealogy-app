import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography scale for the Heirloom Digital Archive.
///
/// Headlines & display → Noto Serif (editorial weight, archival feel).
/// Body, titles, labels → Inter (high readability, 60-70 age demographic).
///
/// Minimum body text size is 18sp (1.125rem at 16px base).
abstract final class AppTextStyles {
  // ── Display / Hero ──────────────────────────────────────────────────────
  /// 56sp — family name hero moments (Noto Serif).
  static TextStyle get displayLg => GoogleFonts.notoSerif(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
        height: 1.1,
      );

  // ── Headlines (Noto Serif) ──────────────────────────────────────────────
  /// 36sp — major section headings.
  static TextStyle get headlineMd => GoogleFonts.notoSerif(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
        height: 1.2,
      );

  /// 24sp — sub-section titles.
  static TextStyle get headlineSm => GoogleFonts.notoSerif(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
        height: 1.3,
      );

  // ── Titles / Body (Inter) ───────────────────────────────────────────────
  /// 22sp — large titles.
  static TextStyle get titleLg => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      );

  /// 18sp — minimum general body text (accessibility for older users).
  static TextStyle get titleMd => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
        height: 1.6,
      );

  /// 16sp — input field labels.
  static TextStyle get titleSm => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
      );

  // ── Labels ──────────────────────────────────────────────────────────────
  /// 14sp — secondary labels.
  static TextStyle get labelMd => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
      );

  /// 11sp ALL CAPS with wide tracking — archival metadata (BORN / DIED).
  static TextStyle get labelSm => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
        letterSpacing: 1.8,
      );

  // ── Quotes (Noto Serif italic) ──────────────────────────────────────────
  static TextStyle get quoteBody => GoogleFonts.notoSerif(
        fontSize: 18,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
        height: 1.7,
      );
}
