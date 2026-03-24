import 'package:provider/provider.dart';
import 'package:doodlevox_mobile/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doodlevox_mobile/utils/dv_shared_prefs.dart';
import 'package:doodlevox_mobile/providers/dv_prefs_provider.dart';
import 'package:doodlevox_mobile/providers/dv_audio_provider.dart';

void main() async {
  // Provide a mock SharedPreferences and initialize DVSharedPrefs
  SharedPreferences.setMockInitialValues({});
  await DVSharedPrefs.init();

  testWidgets(
    'DoodleVox Init Screen Test',
    (WidgetTester tester) async {
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

      printOnFailure("DoodleVox Init Screen Test Failed");
    },
  );
}
