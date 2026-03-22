import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/widgets/dv_logo.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            DVLogo(),
          ],
        ),
      ),
    );
  }
}
