import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:doodlevox_mobile/widgets/dv_logo.dart';
import 'package:doodlevox_mobile/utils/dv_app_info.dart';
import 'package:doodlevox_mobile/styles/dv_qr_scan_style.dart';
import 'package:doodlevox_mobile/providers/dv_daw_provider.dart';
import 'package:doodlevox_mobile/widgets/shared/dv_snackbar.dart';
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
  bool _isConnecting = false;
  bool _hasNavigated = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onQrDetected(BarcodeCapture capture) {
    if (_hasNavigated || _isConnecting) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue != null) {
      _hasNavigated = true;
      _log.info('QR Code scanned: ${barcode!.rawValue}');
      _scannerController.stop();
      setState(() {
        _isScanning = false;
        _isConnecting = true;
      });
      _connectToDaw(barcode.rawValue!);
    }
  }

  Future<void> _connectToDaw(String url) async {
    final dawProvider = context.read<DVDawProvider>();
    final success = await dawProvider.connect(url);

    if (!mounted) return;

    if (success) {
      DVSnackbar.show(
        context,
        message: 'Connected to DAW',
        type: .success,
      );
      context.go('/main/record');
    } else {
      DVSnackbar.show(
        context,
        message: dawProvider.errorMessage ?? 'Connection failed',
        type: .error,
        duration: const Duration(seconds: 4),
      );
      setState(() {
        _isConnecting = false;
        _hasNavigated = false;
      });
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

  @override
  Widget build(BuildContext context) {
    final qrStyle = Theme.of(context).extension<DVQrScanStyle>()!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const .symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 1),
              const DVLogo(size: 80),
              const SizedBox(height: 24),
              Text(
                'Connect to DAW',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: .w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Scan the QR code displayed in the DoodleVox plugin to connect',
                textAlign: .center,
                style: qrStyle.subtitleTextStyle,
              ),
              const Spacer(flex: 1),
              // QR Scanner view
              ClipRRect(
                child: SizedBox(
                  height: 250,
                  width: 250,
                  child: _isConnecting
                      ? Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.05),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.4),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: .min,
                              children: [
                                SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Connecting to DAW...',
                                  style: qrStyle.instructionTextStyle.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : _isScanning
                      ? Stack(
                          children: [
                            MobileScanner(
                              controller: _scannerController,
                              onDetect: _onQrDetected,
                            ),
                            // Scanner border overlay
                            Container(
                              decoration: BoxDecoration(
                                border: .all(
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
                            border: .all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: .min,
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
              if (_isConnecting)
                DVPrimaryButton(
                  label: 'Connecting...',
                  icon: Icons.sync,
                  isLoading: true,
                )
              else if (_isScanning)
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

