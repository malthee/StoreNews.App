
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:storenews/manager/news_notification_manager.dart';
import 'package:storenews/ui/pages/news_overview.dart';
import 'package:storenews/util/constants.dart';
import 'package:storenews/util/service_setup.dart';


final getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerServices(getIt);
  runApp(const StoreNewsApp());
}

class StoreNewsApp extends StatefulWidget {
  const StoreNewsApp({super.key});

  @override
  State<StoreNewsApp> createState() => _StoreNewsAppState();
}

/// App entry state, manages foreground/background state and dark mode. Sets up scanning.
class _StoreNewsAppState extends State<StoreNewsApp>
    with WidgetsBindingObserver {
  final newsNotificationManager = getIt<NewsNotificationManager>();
  bool _darkModeEnabled = false;

  void toggleDarkMode(bool enabled) {
    setState(() {
      _darkModeEnabled = enabled;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    // Only show notifications if the app is in the background.
    newsNotificationManager.appInForeground = state == AppLifecycleState.resumed;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale('en', 'US')],
      theme: ThemeData.from(colorScheme: lightColorScheme, useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      home: NewsOverview(onDarkModeToggle: toggleDarkMode),
    );
  }
}
