import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/styles/dv_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DVRecordScreenStyle extends ThemeExtension<DVRecordScreenStyle> {
  const DVRecordScreenStyle({
    required this.recordingIndicatorColor,
    required this.idleIndicatorColor,
    required this.waveformColor,
    required this.timerTextStyle,
    required this.statusTextStyle,
    required this.playbackIconColor,
  });

  final Color recordingIndicatorColor;
  final Color idleIndicatorColor;
  final Color waveformColor;
  final TextStyle timerTextStyle;
  final TextStyle statusTextStyle;
  final Color playbackIconColor;

  static DVRecordScreenStyle light = DVRecordScreenStyle(
    recordingIndicatorColor: Color(0xFFFF3860),
    idleIndicatorColor: DVColors.tertiary,
    waveformColor: DVColors.primary,
    timerTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 48.spMin,
      fontWeight: .w300,
      color: DVColors.neutral,
    ),
    statusTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 14.spMin,
      fontWeight: .w500,
      color: DVColors.tertiary,
    ),
    playbackIconColor: DVColors.primary,
  );

  static DVRecordScreenStyle dark = DVRecordScreenStyle(
    recordingIndicatorColor: Color(0xFFFF3860),
    idleIndicatorColor: DVColors.tertiary,
    waveformColor: DVColors.primary,
    timerTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 48.spMin,
      fontWeight: .w300,
      color: DVColors.secondary,
    ),
    statusTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 14.spMin,
      fontWeight: FontWeight.w500,
      color: DVColors.tertiary,
    ),
    playbackIconColor: DVColors.primary,
  );

  @override
  ThemeExtension<DVRecordScreenStyle> copyWith({
    Color? recordingIndicatorColor,
    Color? idleIndicatorColor,
    Color? waveformColor,
    TextStyle? timerTextStyle,
    TextStyle? statusTextStyle,
    Color? playbackIconColor,
  }) {
    return DVRecordScreenStyle(
      recordingIndicatorColor:
          recordingIndicatorColor ?? this.recordingIndicatorColor,
      idleIndicatorColor: idleIndicatorColor ?? this.idleIndicatorColor,
      waveformColor: waveformColor ?? this.waveformColor,
      timerTextStyle: timerTextStyle ?? this.timerTextStyle,
      statusTextStyle: statusTextStyle ?? this.statusTextStyle,
      playbackIconColor: playbackIconColor ?? this.playbackIconColor,
    );
  }

  @override
  ThemeExtension<DVRecordScreenStyle> lerp(
    covariant ThemeExtension<DVRecordScreenStyle>? other,
    double t,
  ) {
    if (other is! DVRecordScreenStyle) return this;
    return DVRecordScreenStyle(
      recordingIndicatorColor: Color.lerp(
          recordingIndicatorColor, other.recordingIndicatorColor, t)!,
      idleIndicatorColor:
          Color.lerp(idleIndicatorColor, other.idleIndicatorColor, t)!,
      waveformColor: Color.lerp(waveformColor, other.waveformColor, t)!,
      timerTextStyle:
          TextStyle.lerp(timerTextStyle, other.timerTextStyle, t)!,
      statusTextStyle:
          TextStyle.lerp(statusTextStyle, other.statusTextStyle, t)!,
      playbackIconColor:
          Color.lerp(playbackIconColor, other.playbackIconColor, t)!,
    );
  }
}
