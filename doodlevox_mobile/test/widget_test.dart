import 'package:provider/provider.dart';
import 'package:doodlevox_mobile/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doodlevox_mobile/providers/dv_prefs_provider.dart';
import 'package:doodlevox_mobile/providers/dv_audio_provider.dart';

void main() {
  testWidgets('DoodleVox app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DVPrefsProvider()),
          ChangeNotifierProvider(create: (_) => DVAudioProvider()),
        ],
        child: const DoodleVoxApp(),
      ),
    );

    // Verify initial screen shows QR scanner page
    expect(find.text('Connect to DAW'), findsOneWidget);
    expect(find.text('Scan QR Code'), findsOneWidget);
    expect(find.text('Continue without connecting'), findsOneWidget);
  });
}
