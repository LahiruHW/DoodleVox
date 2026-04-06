import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/styles/dv_colors.dart';
import 'package:doodlevox_mobile/styles/dv_text_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DVEffectsSheetStyle extends ThemeExtension<DVEffectsSheetStyle> {
  const DVEffectsSheetStyle({
    required this.backgroundColor,
    required this.handleColor,
    required this.titleTextStyle,
    required this.itemTextStyle,
    required this.iconColor,
    required this.activeColor,
    required this.dividerColor,
  });

  final Color backgroundColor;
  final Color handleColor;
  final TextStyle titleTextStyle;
  final TextStyle itemTextStyle;
  final Color iconColor;
  final Color activeColor;
  final Color dividerColor;

  static DVEffectsSheetStyle light = DVEffectsSheetStyle(
    backgroundColor: DVColors.secondary,
    handleColor: DVColors.tertiary,
    titleTextStyle: DVTextTheme.titleStyle.copyWith(
      fontSize: 18.spMin,
      fontWeight: .w600,
      color: DVColors.neutral,
    ),
    itemTextStyle: DVTextTheme.bodyStyle.copyWith(
      fontSize: 14.spMin,
      fontWeight: .w500,
      color: DVColors.neutral,
    ),
    iconColor: DVColors.tertiary,
    activeColor: DVColors.primary,
    dividerColor: DVColors.tertiary.withValues(alpha: 0.2),
  );

  static DVEffectsSheetStyle dark = DVEffectsSheetStyle(
    backgroundColor: DVColors.neutral,
    handleColor: DVColors.tertiary,
    titleTextStyle: DVTextTheme.titleStyle.copyWith(
      fontSize: 18.spMin,
      fontWeight: .w600,
      color: DVColors.secondary,
    ),
    itemTextStyle: DVTextTheme.bodyStyle.copyWith(
      fontSize: 14.spMin,
      fontWeight: .w500,
      color: DVColors.secondary,
    ),
    iconColor: DVColors.tertiary,
    activeColor: DVColors.primary,
    dividerColor: DVColors.tertiary.withValues(alpha: 0.2),
  );

  @override
  ThemeExtension<DVEffectsSheetStyle> copyWith({
    Color? backgroundColor,
    Color? handleColor,
    TextStyle? titleTextStyle,
    TextStyle? itemTextStyle,
    Color? iconColor,
    Color? activeColor,
    Color? dividerColor,
  }) {
    return DVEffectsSheetStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      handleColor: handleColor ?? this.handleColor,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      itemTextStyle: itemTextStyle ?? this.itemTextStyle,
      iconColor: iconColor ?? this.iconColor,
      activeColor: activeColor ?? this.activeColor,
      dividerColor: dividerColor ?? this.dividerColor,
    );
  }

  @override
  ThemeExtension<DVEffectsSheetStyle> lerp(
    covariant ThemeExtension<DVEffectsSheetStyle>? other,
    double t,
  ) {
    if (other is! DVEffectsSheetStyle) return this;
    return DVEffectsSheetStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      handleColor: Color.lerp(handleColor, other.handleColor, t)!,
      titleTextStyle: TextStyle.lerp(titleTextStyle, other.titleTextStyle, t)!,
      itemTextStyle: TextStyle.lerp(itemTextStyle, other.itemTextStyle, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      activeColor: Color.lerp(activeColor, other.activeColor, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
    );
  }
}
