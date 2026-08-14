import 'package:flutter/material.dart';

class SlideRoute<T> extends PageRouteBuilder<T> {
  SlideRoute({required Widget page, super.settings})
    : super(
        transitionDuration: const Duration(milliseconds: 240),
        reverseTransitionDuration: const Duration(milliseconds: 240),
        pageBuilder: (_, _, _) => page,
        transitionsBuilder: (_, animation, _, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          final begin = animation.status == AnimationStatus.reverse
              ? const Offset(-1.0, 0.0) // pop
              : const Offset(1.0, 0.0); // push

          return SlideTransition(
            position: Tween<Offset>(
              begin: begin,
              end: Offset.zero,
            ).animate(curved),
            child: child,
          );
        },
      );
}
