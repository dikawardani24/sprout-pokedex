
import 'package:core_ui/core_ui.dart';
import 'package:feature_home/feauture_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:sprout_pokedex/navigation/routes.dart';
import 'package:sprout_pokedex/pages/detail/detail_page.dart';

extension AppNavigation on BuildContext {
  Future<dynamic> _goToPage(
      String route,
      {bool isRootPage = false, Object? data}
      ) => goToPageWithRouteName(route, isRootPage: isRootPage, data);

  Future<dynamic> startHomePage() => _goToPage(Routes.home);
  Future<dynamic> startDetailPage(int id) => _goToPage(Routes.detail, data: id);

  Widget? _getPage(String? routeName, Object? args) {
    switch(routeName) {
      case Routes.home : return HomePage(
        onTap: (c, selected) => c.startDetailPage(selected.id),
      );
      case Routes.detail:
        if (args is int) {
          return DetailPage(id: args);
        }
        return null;
      default: return null;
    }
  }

  RouteFactory getRouteGenerator() => (settings) {
    final destination = _getPage(settings.name, settings.arguments);
    if (destination != null) {
      return createRoute(destination);
    }
    return null;
  };
}