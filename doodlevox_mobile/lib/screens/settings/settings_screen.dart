import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 20.spMin,
          alignment: .centerRight.add(Alignment.centerRight * 0.8),
          tooltip: null,
          visualDensity: .adaptivePlatformDensity,
          onPressed: () => context.pop(),
        ),
      ),
      
    );
  }
}