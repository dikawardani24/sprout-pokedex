import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:sprout_pokedex/di/injection.dart';
import 'package:sprout_pokedex/navigation/app_navigation.dart';
import 'package:sprout_pokedex/navigation/routes.dart';

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
      debugShowCheckedModeBanner: false,
      title: StringRes.appName,
      themeMode: ThemeRes.themeMode,
      darkTheme: ThemeRes.getTheme(false),
      theme: ThemeRes.getTheme(false),
      onGenerateRoute: context.getRouteGenerator(),
      initialRoute: Routes.home,
    );
  }
}
