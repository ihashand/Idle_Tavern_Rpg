import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_template/constants/settings.dart';
import 'package:game_template/src/graphic_tavern_interior/graphic_tavern_interior.dart';
import 'package:game_template/src/playable_screens/wood_storage_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'src/ads/ads_controller.dart';
import 'src/app_lifecycle/app_lifecycle.dart';
import 'src/audio/audio_controller.dart';
import 'src/games_services/games_services.dart';
import 'src/in_app_purchase/in_app_purchase.dart';
import 'src/town_menu/town_menu_screen.dart';
import 'src/main_menu/main_menu_screen.dart';
import 'src/settings/persistence/local_storage_settings_persistence.dart';
import 'src/settings/persistence/settings_persistence.dart';
import 'src/settings/settings.dart';
import 'src/settings/settings_screen.dart';
import 'src/style/my_transition.dart';
import 'src/style/palette.dart';
import 'src/style/snack_bar.dart';
import 'package:provider/provider.dart' as provider;
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

Future<void> main() async {
  // Subscribe to log messages.
  Logger.root.onRecord.listen((record) {
    dev.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
      zone: record.zone,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // TODO: To enable Firebase Crashlytics, uncomment the following line.
  // See the 'Crashlytics' section of the main README.md file for details.

  // if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
  //   try {
  //     await Firebase.initializeApp(
  //       options: DefaultFirebaseOptions.currentPlatform,
  //     );
  //
  //     FlutterError.onError = (errorDetails) {
  //       FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  //     };
  //
  //     // Pass all uncaught asynchronous errors
  //     // that aren't handled by the Flutter framework to Crashlytics.
  //     PlatformDispatcher.instance.onError = (error, stack) {
  //       FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //       return true;
  //     };
  //   } catch (e) {
  //     debugPrint("Firebase couldn't be initialized: $e");
  //   }
  // }

  _log.info('Going full screen');
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  // TODO: When ready, uncomment the following lines to enable integrations.
  //       Read the README for more info on each integration.

  AdsController? adsController;
  // if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
  //   /// Prepare the google_mobile_ads plugin so that the first ad loads
  //   /// faster. This can be done later or with a delay if startup
  //   /// experience suffers.
  //   adsController = AdsController(MobileAds.instance);
  //   adsController.initialize();
  // }

  GamesServicesController? gamesServicesController;
  // if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
  //   gamesServicesController = GamesServicesController()
  //     // Attempt to log the player in.
  //     ..initialize();
  // }

  InAppPurchaseController? inAppPurchaseController;
  // if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
  //   inAppPurchaseController = InAppPurchaseController(InAppPurchase.instance)
  //     // Subscribing to [InAppPurchase.instance.purchaseStream] as soon
  //     // as possible in order not to miss any updates.
  //     ..subscribe();
  //   // Ask the store what the player has bought already.
  //   inAppPurchaseController.restorePurchases();
  // }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('de'), Locale('pl')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: riverpod.ProviderScope(
        child: MyApp(
          settingsPersistence: LocalStorageSettingsPersistence(),
          inAppPurchaseController: inAppPurchaseController,
          adsController: adsController,
          gamesServicesController: gamesServicesController,
        ),
      ),
    ),
  );
}

Logger _log = Logger('main.dart');

class MyApp extends StatelessWidget {
  static final _router = GoRouter(
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) => MainMenuScreen(key: Key('main menu')),
          routes: [
            GoRoute(
              path: 'play',
              pageBuilder: (context, state) {
                final settings = context.read<SettingsController>();
                if (settings.graphicModeOn.value == true) {
                  return buildMyTransition<void>(
                    key: ValueKey('play'),
                    child: GraphicTavernInteriorScreen(),
                    color: context.watch<Palette>().backgroundLevelSelection,
                  );
                }
                return buildMyTransition<void>(
                  key: ValueKey('play'),
                  child: const TownMenuScreen(
                    key: Key('level selection'),
                  ),
                  color: context.watch<Palette>().backgroundLevelSelection,
                );
              },
            ),
            GoRoute(
              path: 'interior',
              pageBuilder: (context, state) {
                return buildMyTransition<void>(
                  key: ValueKey('interior'),
                  child: GraphicTavernInteriorScreen(),
                  color: context.watch<Palette>().backgroundLevelSelection,
                );
              },
            ),
            GoRoute(
              path: 'settings',
              builder: (context, state) =>
                  const SettingsScreen(key: Key('settings')),
            ),
            GoRoute(
              path: 'woodStorage',
              pageBuilder: (context, state) {
                return buildMyTransition<void>(
                  key: ValueKey('woodStorage'),
                  child: WoodStorageScreen(),
                  color: context.watch<Palette>().backgroundLevelSelection,
                );
              },
            ),
          ]),
    ],
  );

  final SettingsPersistence settingsPersistence;
  final GamesServicesController? gamesServicesController;
  final InAppPurchaseController? inAppPurchaseController;
  final AdsController? adsController;

  const MyApp({
    required this.settingsPersistence,
    required this.inAppPurchaseController,
    required this.adsController,
    required this.gamesServicesController,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          Provider<GamesServicesController?>.value(
            value: gamesServicesController,
          ),
          Provider<AdsController?>.value(
            value: adsController,
          ),
          ChangeNotifierProvider<InAppPurchaseController?>.value(
            value: inAppPurchaseController,
          ),
          Provider<SettingsController>(
            lazy: false,
            create: (context) => SettingsController(
              persistence: settingsPersistence,
            )..loadStateFromPersistence(),
          ),
          ProxyProvider2<SettingsController, ValueNotifier<AppLifecycleState>,
              AudioController>(
            lazy: false,
            create: (context) => AudioController()..initialize(),
            update: (context, settings, lifecycleNotifier, audio) {
              if (audio == null) throw ArgumentError.notNull();
              audio.attachSettings(settings);
              audio.attachLifecycleNotifier(lifecycleNotifier);
              return audio;
            },
            dispose: (context, audio) => audio.dispose(),
          ),
          Provider(
            create: (context) => Palette(),
          ),
        ],
        child: Builder(builder: (context) {
          final palette = context.watch<Palette>();

          Future<Locale> getLocaleFromSettings() async {
            final selectedLanguage = await settingsPersistence.getAppLanguage();
            Locale locale = _mapAppLanguageToLocale(selectedLanguage);
            // ignore: use_build_context_synchronously
            context.setLocale(locale);
            return locale;
          }

          return FutureBuilder<Locale>(
            future: getLocaleFromSettings(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return MaterialApp.router(
                  title: 'Flutter Demo',
                  locale: context.locale,
                  supportedLocales: context.supportedLocales,
                  localizationsDelegates: context.localizationDelegates,
                  theme: ThemeData.from(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: palette.darkPen,
                      background: palette.backgroundMain,
                    ),
                    textTheme: TextTheme(
                      bodyMedium: TextStyle(
                        color: palette.ink,
                      ),
                    ),
                    useMaterial3: true,
                  ),
                  routeInformationProvider: _router.routeInformationProvider,
                  routeInformationParser: _router.routeInformationParser,
                  routerDelegate: _router.routerDelegate,
                  scaffoldMessengerKey: scaffoldMessengerKey,
                );
              } else {
                return CircularProgressIndicator(); // Or any other loading indicator
              }
            },
          );
        }),
      ),
    );
  }

  Locale _mapAppLanguageToLocale(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return const Locale('en');
      case AppLanguage.polish:
        return const Locale('pl');
      case AppLanguage.german:
        return const Locale('de');
      // Add other cases as needed
      default:
        return const Locale('en'); // Default to English
    }
  }
}
