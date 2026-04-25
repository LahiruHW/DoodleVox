import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/styles/dv_colors.dart';
import 'package:doodlevox_mobile/styles/dv_text_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DVSettingsScreenStyle extends ThemeExtension<DVSettingsScreenStyle> {
  const DVSettingsScreenStyle({
    required this.sectionTitleStyle,
    required this.itemTitleStyle,
    required this.itemSubtitleStyle,
    required this.iconColor,
    required this.activeColor,
    required this.dividerColor,
    required this.tileColor,
  });

  final TextStyle sectionTitleStyle;
  final TextStyle itemTitleStyle;
  final TextStyle itemSubtitleStyle;
  final Color iconColor;
  final Color activeColor;
  final Color dividerColor;
  final Color tileColor;

  static DVSettingsScreenStyle light = DVSettingsScreenStyle(
    sectionTitleStyle: DVTextTheme.labelStyle.copyWith(
      fontSize: 12.spMin,
      fontWeight: FontWeight.w600,
      color: DVColors.tertiary,
    ),
    itemTitleStyle: DVTextTheme.bodyStyle.copyWith(
      fontSize: 16.spMin,
      fontWeight: FontWeight.w500,
      color: DVColors.neutral,
    ),
    itemSubtitleStyle: DVTextTheme.labelStyle.copyWith(
      fontSize: 13.spMin,
      fontWeight: FontWeight.w400,
      color: DVColors.tertiary,
    ),
    iconColor: DVColors.tertiary,
    activeColor: DVColors.primary,
    dividerColor: DVColors.tertiary.withValues(alpha: 0.2),
    tileColor: Colors.white,
  );

  static DVSettingsScreenStyle dark = DVSettingsScreenStyle(
    sectionTitleStyle: DVTextTheme.labelStyle.copyWith(
      fontSize: 12.spMin,
      fontWeight: FontWeight.w600,
      color: DVColors.tertiary,
    ),
    itemTitleStyle: DVTextTheme.bodyStyle.copyWith(
      fontSize: 16.spMin,
      fontWeight: FontWeight.w500,
      color: DVColors.secondary,
    ),
    itemSubtitleStyle: DVTextTheme.labelStyle.copyWith(
      fontSize: 13.spMin,
      fontWeight: FontWeight.w400,
      color: DVColors.tertiary,
    ),
    iconColor: DVColors.tertiary,
    activeColor: DVColors.primary,
    dividerColor: DVColors.tertiary.withValues(alpha: 0.2),
    tileColor: const Color(0xFF1E1E1E),
  );

  @override
  ThemeExtension<DVSettingsScreenStyle> copyWith({
    TextStyle? sectionTitleStyle,
    TextStyle? itemTitleStyle,
    TextStyle? itemSubtitleStyle,
    Color? iconColor,
    Color? activeColor,
    Color? dividerColor,
    Color? tileColor,
  }) {
    return DVSettingsScreenStyle(
      sectionTitleStyle: sectionTitleStyle ?? this.sectionTitleStyle,
      itemTitleStyle: itemTitleStyle ?? this.itemTitleStyle,
      itemSubtitleStyle: itemSubtitleStyle ?? this.itemSubtitleStyle,
      iconColor: iconColor ?? this.iconColor,
      activeColor: activeColor ?? this.activeColor,
      dividerColor: dividerColor ?? this.dividerColor,
      tileColor: tileColor ?? this.tileColor,
    );
  }

  @override
  ThemeExtension<DVSettingsScreenStyle> lerp(
    covariant ThemeExtension<DVSettingsScreenStyle>? other,
    double t,
  ) {
    if (other is! DVSettingsScreenStyle) return this;
    return DVSettingsScreenStyle(
      sectionTitleStyle: TextStyle.lerp(sectionTitleStyle, other.sectionTitleStyle, t)!,
      itemTitleStyle: TextStyle.lerp(itemTitleStyle, other.itemTitleStyle, t)!,
      itemSubtitleStyle: TextStyle.lerp(itemSubtitleStyle, other.itemSubtitleStyle, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      activeColor: Color.lerp(activeColor, other.activeColor, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      tileColor: Color.lerp(tileColor, other.tileColor, t)!,
    );
  }
}
