import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'navigation/bottom_nav.dart';
import 'map/offline_map.dart';
import 'monetization/premium_gate.dart';
import 'l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local caching
  await Hive.initFlutter();
  await Hive.openBox('places');
  await Hive.openBox('saved_places');
  await Hive.openBox('user_prefs');

  // Initialize offline tile cache
  await OfflineTileManager.init();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enable Firestore offline persistence
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // Initialize premium status
  await PremiumManager.init();

  runApp(const GoIcelandApp());
}

class GoIcelandApp extends StatelessWidget {
  const GoIcelandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GO ICELAND',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: AppTheme.dark,

      // Localization
      supportedLocales: L10n.supported,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },

      home: const BottomNav(),
    );
  }
}
