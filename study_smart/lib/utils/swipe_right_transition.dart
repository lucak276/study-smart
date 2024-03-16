import 'package:flutter/material.dart';

class SwipeRightTransition extends PageRouteBuilder {
  final Widget widget;
  SwipeRightTransition({required this.widget})
  : super(
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return widget;
    },
  );
}