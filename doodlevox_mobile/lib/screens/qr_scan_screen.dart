import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:doodlevox_mobile/widgets/dv_logo.dart';
import 'package:doodlevox_mobile/utils/dv_app_info.dart';
import 'package:doodlevox_mobile/styles/dv_qr_scan_style.dart';
import 'package:doodlevox_mobile/widgets/shared/dv_alert_dialog.dart';
import 'package:doodlevox_mobile/widgets/shared/dv_primary_button.dart';
import 'package:doodlevox_mobile/widgets/shared/dv_secondary_button.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  static final _log = Logger('QRScanScreen');
  final MobileScannerController _scannerController = MobileScannerController(
    autoStart: false,
  );
  bool _isScanning = false;
  bool _hasNavigated = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onQrDetected(BarcodeCapture capture) {
    if (_hasNavigated) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue != null) {
      _hasNavigated = true;
      _log.info('QR Code scanned: ${barcode!.rawValue}');
      _scannerController.stop();
      setState(() => _isScanning = false);
      context.go('/main/record');
    }
  }

  void _startScanning() {
    setState(() => _isScanning = true);
    _hasNavigated = false;
    _scannerController.start();
  }

  void _stopScanning() {
    _scannerController.stop();
    setState(() => _isScanning = false);
  }

  void _continueWithoutConnecting() {
    _log.info('Continuing without DAW connection');
    context.go('/main/record');
  }

  void _showNoteDialog() {
    final a = """
At the moment, DoodleVox is in its early stages and thus, some features are still in development as we are still working on the DAW integration. 

However, you can still explore the app and use the recording features without connecting to a DAW.

DoodleVox is not just an Audio Recorder, but a tool intended for music producers to quickly capture ideas without breaking their creative flow.
    """;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DVAlertDialog.show(
        context,
        title: 'Still Doodling...',
        content: a,
        barrierDismissible: false,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _showNoteDialog();
  }

  @override
  Widget build(BuildContext context) {
    final qrStyle = Theme.of(context).extension<DVQrScanStyle>()!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 1),
              const DVLogo(size: 80),
              const SizedBox(height: 24),
              Text(
                'Connect to DAW',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Scan the QR code displayed in your DAW to connect',
                textAlign: TextAlign.center,
                style: qrStyle.subtitleTextStyle,
              ),
              const Spacer(flex: 1),
              // QR Scanner view
              ClipRRect(
                child: SizedBox(
                  height: 250,
                  width: 250,
                  child: _isScanning
                      ? Stack(
                          children: [
                            MobileScanner(
                              controller: _scannerController,
                              onDetect: _onQrDetected,
                            ),
                            // Scanner border overlay
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: qrStyle.scannerBorderColor,
                                  width: 2,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.05),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.qr_code_scanner,
                                  size: 64,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.3),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'QR Scanner',
                                  style: qrStyle.instructionTextStyle.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
              const Spacer(flex: 2),
              // Buttons
              if (_isScanning)
                DVSecondaryButton(
                  label: 'Cancel Scan',
                  icon: Icons.close,
                  onPressed: _stopScanning,
                )
              else
                DVPrimaryButton(
                  label: 'Scan QR Code',
                  icon: Icons.qr_code_scanner,
                  onPressed: _startScanning,
                ),
              const SizedBox(height: 12),
              DVSecondaryButton(
                label: 'Continue without connecting',
                onPressed: _continueWithoutConnecting,
              ),
              const SizedBox(height: 32),
              Text(
                'v${DVAppInfo.version} (build ${DVAppInfo.buildNumber})',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(60),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

