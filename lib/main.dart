import 'package:flutter/material.dart';
import 'package:sprout_pokedex/navigation/app_navigation.dart';
import 'package:sprout_pokedex/navigation/routes.dart';
import 'package:sprout_pokedex/res/string_res.dart';
import 'package:sprout_pokedex/res/theme_res.dart';

import 'di/injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: StringRes.appName,
      themeMode: ThemeRes.themeMode,
      darkTheme: ThemeRes.getTheme(true),
      theme: ThemeRes.getTheme(false),
      onGenerateRoute: context.getRouteGenerator(),
      initialRoute: Routes.home,
    );
  }
}
