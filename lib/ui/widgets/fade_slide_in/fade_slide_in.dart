import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_motion.dart';

/// Entrada sutil (fade + slide de baixo pra cima) para itens de lista,
/// usando só primitivas do Flutter — sem pacote de animação novo.
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppMotion.medium,
      curve: AppMotion.curve,
      builder: (context, value, animatedChild) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 12),
            child: animatedChild,
          ),
        );
      },
      child: child,
    );
  }
}
