import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/styles/dv_themes.dart';

class DVQrScanStyle extends ThemeExtension<DVQrScanStyle> {
  const DVQrScanStyle({
    required this.scannerOverlayColor,
    required this.scannerBorderColor,
    required this.instructionTextStyle,
    required this.subtitleTextStyle,
  });

  final Color scannerOverlayColor;
  final Color scannerBorderColor;
  final TextStyle instructionTextStyle;
  final TextStyle subtitleTextStyle;

  static const DVQrScanStyle light = DVQrScanStyle(
    scannerOverlayColor: Color(0x88000000),
    scannerBorderColor: DVTheme.primaryColor,
    instructionTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: DVTheme.neutralColor,
    ),
    subtitleTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: DVTheme.tertiaryColor,
    ),
  );

  static const DVQrScanStyle dark = DVQrScanStyle(
    scannerOverlayColor: Color(0x88000000),
    scannerBorderColor: DVTheme.primaryColor,
    instructionTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: DVTheme.secondaryColor,
    ),
    subtitleTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: DVTheme.tertiaryColor,
    ),
  );

  @override
  ThemeExtension<DVQrScanStyle> copyWith({
    Color? scannerOverlayColor,
    Color? scannerBorderColor,
    TextStyle? instructionTextStyle,
    TextStyle? subtitleTextStyle,
  }) {
    return DVQrScanStyle(
      scannerOverlayColor: scannerOverlayColor ?? this.scannerOverlayColor,
      scannerBorderColor: scannerBorderColor ?? this.scannerBorderColor,
      instructionTextStyle: instructionTextStyle ?? this.instructionTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? this.subtitleTextStyle,
    );
  }

  @override
  ThemeExtension<DVQrScanStyle> lerp(
    covariant ThemeExtension<DVQrScanStyle>? other,
    double t,
  ) {
    if (other is! DVQrScanStyle) return this;
    return DVQrScanStyle(
      scannerOverlayColor:
          Color.lerp(scannerOverlayColor, other.scannerOverlayColor, t)!,
      scannerBorderColor:
          Color.lerp(scannerBorderColor, other.scannerBorderColor, t)!,
      instructionTextStyle:
          TextStyle.lerp(instructionTextStyle, other.instructionTextStyle, t)!,
      subtitleTextStyle:
          TextStyle.lerp(subtitleTextStyle, other.subtitleTextStyle, t)!,
    );
  }
}
