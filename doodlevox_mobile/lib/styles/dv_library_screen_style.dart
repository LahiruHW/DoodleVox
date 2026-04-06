import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/styles/dv_colors.dart';
import 'package:doodlevox_mobile/styles/dv_text_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DVLibraryScreenStyle extends ThemeExtension<DVLibraryScreenStyle> {
  const DVLibraryScreenStyle({
    required this.titleTextStyle,
    required this.subtitleTextStyle,
    required this.emptyTextStyle,
    required this.emptyIconColor,
    required this.waveformColor,
    required this.waveformInactiveColor,
    required this.cardColor,
    required this.syncBadgeColor,
    required this.deleteColor,
  });

  final TextStyle titleTextStyle;
  final TextStyle subtitleTextStyle;
  final TextStyle emptyTextStyle;
  final Color emptyIconColor;
  final Color waveformColor;
  final Color waveformInactiveColor;
  final Color cardColor;
  final Color syncBadgeColor;
  final Color deleteColor;

  static DVLibraryScreenStyle light = DVLibraryScreenStyle(
    titleTextStyle: DVTextTheme.bodyStyle.copyWith(
      fontSize: 16.spMin,
      fontWeight: FontWeight.w500,
      color: DVColors.neutral,
    ),
    subtitleTextStyle: DVTextTheme.labelStyle.copyWith(
      fontSize: 12.spMin,
      color: DVColors.tertiary,
    ),
    emptyTextStyle: DVTextTheme.bodyStyle.copyWith(
      fontSize: 14.spMin,
      color: DVColors.tertiary,
    ),
    emptyIconColor: DVColors.tertiary.withValues(alpha: 0.3),
    waveformColor: DVColors.primary,
    waveformInactiveColor: DVColors.tertiary.withValues(alpha: 0.3),
    cardColor: Colors.white,
    syncBadgeColor: DVColors.primary,
    deleteColor: const Color(0xFFFF3860),
  );

  static DVLibraryScreenStyle dark = DVLibraryScreenStyle(
    titleTextStyle: DVTextTheme.bodyStyle.copyWith(
      fontSize: 16.spMin,
      fontWeight: FontWeight.w500,
      color: DVColors.secondary,
    ),
    subtitleTextStyle: DVTextTheme.labelStyle.copyWith(
      fontSize: 12.spMin,
      color: DVColors.tertiary,
    ),
    emptyTextStyle: DVTextTheme.bodyStyle.copyWith(
      fontSize: 14.spMin,
      color: DVColors.tertiary,
    ),
    emptyIconColor: DVColors.tertiary.withValues(alpha: 0.3),
    waveformColor: DVColors.primary,
    waveformInactiveColor: DVColors.tertiary.withValues(alpha: 0.3),
    cardColor: const Color(0xFF1E1E1E),
    syncBadgeColor: DVColors.primary,
    deleteColor: const Color(0xFFFF3860),
  );

  @override
  ThemeExtension<DVLibraryScreenStyle> copyWith({
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
    TextStyle? emptyTextStyle,
    Color? emptyIconColor,
    Color? waveformColor,
    Color? waveformInactiveColor,
    Color? cardColor,
    Color? syncBadgeColor,
    Color? deleteColor,
  }) {
    return DVLibraryScreenStyle(
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? this.subtitleTextStyle,
      emptyTextStyle: emptyTextStyle ?? this.emptyTextStyle,
      emptyIconColor: emptyIconColor ?? this.emptyIconColor,
      waveformColor: waveformColor ?? this.waveformColor,
      waveformInactiveColor:
          waveformInactiveColor ?? this.waveformInactiveColor,
      cardColor: cardColor ?? this.cardColor,
      syncBadgeColor: syncBadgeColor ?? this.syncBadgeColor,
      deleteColor: deleteColor ?? this.deleteColor,
    );
  }

  @override
  ThemeExtension<DVLibraryScreenStyle> lerp(
    covariant ThemeExtension<DVLibraryScreenStyle>? other,
    double t,
  ) {
    if (other is! DVLibraryScreenStyle) return this;
    return DVLibraryScreenStyle(
      titleTextStyle: TextStyle.lerp(titleTextStyle, other.titleTextStyle, t)!,
      subtitleTextStyle: TextStyle.lerp(
        subtitleTextStyle,
        other.subtitleTextStyle,
        t,
      )!,
      emptyTextStyle: TextStyle.lerp(emptyTextStyle, other.emptyTextStyle, t)!,
      emptyIconColor: Color.lerp(emptyIconColor, other.emptyIconColor, t)!,
      waveformColor: Color.lerp(waveformColor, other.waveformColor, t)!,
      waveformInactiveColor: Color.lerp(
        waveformInactiveColor,
        other.waveformInactiveColor,
        t,
      )!,
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      syncBadgeColor: Color.lerp(syncBadgeColor, other.syncBadgeColor, t)!,
      deleteColor: Color.lerp(deleteColor, other.deleteColor, t)!,
    );
  }
}
