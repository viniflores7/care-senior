import 'package:flutter/material.dart';

/// Duração e curva padrão para animações implícitas do app — evita valores
/// mágicos espalhados e mantém o movimento consistente entre telas.
class AppMotion {
  AppMotion._();

  static const Duration fast = Duration(milliseconds: 180);
  static const Duration medium = Duration(milliseconds: 280);
  static const Curve curve = Curves.easeOutCubic;
}
