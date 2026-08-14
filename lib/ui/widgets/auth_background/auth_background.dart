import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_color.dart';

/// Fundo decorativo com "blobs" orgânicos roxos, usado nas telas de
/// login/seleção de papel para lembrar o visual do Figma original.
class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned(
          top: -60,
          left: -60,
          child: _Blob(size: 200, color: AppColor.primary, opacity: 0.25),
        ),
        const Positioned(
          bottom: -90,
          right: -70,
          child: _Blob(size: 240, color: AppColor.primaryDark, opacity: 0.15),
        ),
        child,
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color, required this.opacity});

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}
