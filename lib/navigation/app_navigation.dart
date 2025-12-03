
import 'package:core_ui/core_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:sprout_pokedex/navigation/pages.dart';
import 'package:sprout_pokedex/navigation/routes.dart';

extension AppNavigation on BuildContext {
  Future<dynamic> _goToPage(
      String route,
      {bool isRootPage = false, Object? data}
      ) => goToPageWithRouteName(route, isRootPage: isRootPage, data);

  Future<dynamic> startHomePage() => _goToPage(Routes.home, isRootPage: true);
  Future<dynamic> startDetailPage(int id) => _goToPage(Routes.detail, data: id);
  Future<dynamic> startChatPage() => _goToPage(Routes.chat);
  Future<dynamic> startChatPageWithPokemon(int id) => _goToPage(Routes.chatPokemon, data: id);
  Future<dynamic> startChatHistoryPage() => _goToPage(Routes.chatHistory);

  Widget? _getPage(String? routeName, Object? args) {
    switch(routeName) {
      case Routes.home : return Pages.homePage(
          onStartChat: (c) => c.startChatPage(),
          onStartDetail: (c, selected) => c.startDetailPage(selected.id)
      );
      case Routes.detail:
        if (args is int) return Pages.detailPage(args);
      case Routes.chat: return Pages.chatPage(
        onStartChatHistory: (c) => c.startChatHistoryPage()
      );
      case Routes.chatPokemon:
        if (args is int) {
          return Pages.chatPage(
              id: args,
              onStartChatHistory: (c) => c.startChatHistoryPage()
          );
        }
      case Routes.chatHistory: return Pages.chatHistoryPage();
      default: return null;
    }
    return null;
  }

  RouteFactory getRouteGenerator() => (settings) {
    final destination = _getPage(settings.name, settings.arguments);
    if (destination != null) {
      return createRoute(destination);
    }
    return null;
  };
}