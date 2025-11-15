
import 'package:flutter/material.dart';

extension NavigationExt on BuildContext {

  PageRoute<dynamic> createRoute(
     Widget destination,
     { bool isFullscreenDialog = false}
  ) {
   return MaterialPageRoute(
       fullscreenDialog: isFullscreenDialog,
       builder: (BuildContext context) => destination
   );
  }

  Future<dynamic> goToPage(
      Widget destination,
      { bool isRootPage = false, bool isScreenDialog = false}
  ) {
    final route = createRoute(destination, isFullscreenDialog: isScreenDialog);
    if (isRootPage) {
      return Navigator.pushReplacement(this, route);
    }
    return Navigator.push(this, route);
  }

  Future<dynamic> goToPageWithRouteName(
      String routeName,
      Object? argument,
      {bool isRootPage = false}
  ) {
    if (isRootPage) return Navigator.pushReplacementNamed(this, routeName, arguments: argument);
    return Navigator.pushNamed(this, routeName, arguments: argument);
  }

  void goBack<T extends Object?>([ T? result ]) {
    Navigator.pop(this, result);
  }

  void goBackToFirstPage() {
    Navigator.popUntil(this, (route) => route.isFirst);
  }
}
