import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:doodlevox_mobile/utils/dv_app_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:doodlevox_mobile/providers/dv_prefs_provider.dart';
import 'package:doodlevox_mobile/providers/dv_audio_provider.dart';
import 'package:doodlevox_mobile/styles/dv_settings_screen_style.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).extension<DVSettingsScreenStyle>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 20.spMin,
          alignment: Alignment.centerRight.add(Alignment.centerRight * 0.8),
          tooltip: null,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<DVPrefsProvider>(
        builder: (context, prefs, _) {
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            children: [
              // — Appearance —
              _SectionHeader(title: 'APPEARANCE', style: style),
              SizedBox(height: 8.h),
              _SettingsTile(
                style: style,
                icon: prefs.themeMode == ThemeMode.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
                title: 'Dark Mode',
                trailing: Switch.adaptive(
                  value: prefs.themeMode == ThemeMode.dark,
                  activeTrackColor: style.activeColor,
                  onChanged: (_) => prefs.toggleThemeMode(),
                ),
              ),
              Divider(height: 1, color: style.dividerColor),

              SizedBox(height: 24.h),

              // — Recording —
              _SectionHeader(title: 'RECORDING', style: style),
              SizedBox(height: 8.h),
              _SettingsTile(
                style: style,
                icon: Icons.audiotrack,
                title: 'Audio Format',
                subtitle: encoderLabel[prefs.encoding] ?? 'WAV',
                onTap: () => _showEncodingPicker(context, prefs),
              ),

              SizedBox(height: 24.h),

              // — About —
              _SectionHeader(title: 'ABOUT', style: style),
              SizedBox(height: 8.h),
              _SettingsTile(
                style: style,
                icon: Icons.info_outline,
                title: 'Version',
                // subtitle: '1.0.0',
                subtitle:
                    '${DVAppInfo.version} (build ${DVAppInfo.buildNumber})',
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEncodingPicker(BuildContext context, DVPrefsProvider prefs) {
    final style = Theme.of(context).extension<DVSettingsScreenStyle>()!;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: style.iconColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),
              Text('Audio Format', style: style.itemTitleStyle),
              SizedBox(height: 8.h),
              ...supportedEncoderKeys.map((key) {
                final isSelected = prefs.encoding == key;
                return ListTile(
                  leading: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected ? style.activeColor : style.iconColor,
                  ),
                  title: Text(encoderLabel[key]!, style: style.itemTitleStyle),
                  onTap: () {
                    prefs.setEncoding(key);
                    Navigator.pop(context);
                  },
                );
              }),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.style});

  final String title;
  final DVSettingsScreenStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(title, style: style.sectionTitleStyle),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.style,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final DVSettingsScreenStyle style;
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: style.tileColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      leading: Icon(icon, color: style.iconColor, size: 22.spMin),
      title: Text(title, style: style.itemTitleStyle),
      subtitle: subtitle != null
          ? Text(subtitle!, style: style.itemSubtitleStyle)
          : null,
      trailing:
          trailing ??
          (onTap != null
              ? Icon(Icons.chevron_right, color: style.iconColor)
              : null),
      onTap: onTap,
    );
  }
}
