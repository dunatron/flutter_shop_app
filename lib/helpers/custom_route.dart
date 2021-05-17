import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Single route on the fly creation
class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(
          builder: builder,
          settings: settings,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == '/') {
      return child; // dont want to animate initial page
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

// for app wide route transition effects specified in ThemeData.pageTransitionsTheme
class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.settings.name == '/') {
      return child; // dont want to animate initial page
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
