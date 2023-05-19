import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:i18n_extension/default.i18n.dart';
import 'package:storenews/ui/pages/news_overview.dart';
import 'package:storenews/util/constants.dart';

final getIt = GetIt.instance;

void main() {
  setupGetIt();
  runApp(const StoreNewsApp());
}

void setupGetIt() {
  //getIt.registerSingleton(instance)
}

class StoreNewsApp extends StatelessWidget {
  const StoreNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en', 'US')
      ],
      theme: ThemeData.from(colorScheme: lightColorScheme, useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.light,
      home: NewsOverview(),
    );
  }
}