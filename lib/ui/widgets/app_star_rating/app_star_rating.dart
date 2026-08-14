import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_color.dart';

/// Seletor/indicador de nota de 1 a 5 estrelas. Sem [onChanged], vira
/// somente leitura (usado para exibir uma nota já dada).
class AppStarRating extends StatelessWidget {
  const AppStarRating({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 32,
  });

  final int value;
  final ValueChanged<int>? onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    final readOnly = onChanged == null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final icon = Icon(
          starValue <= value ? Icons.star : Icons.star_border,
          color: AppColor.warning,
          size: size,
        );

        if (readOnly) return icon;

        return InkWell(
          onTap: () => onChanged!(starValue),
          borderRadius: BorderRadius.circular(size),
          child: Padding(padding: const EdgeInsets.all(4), child: icon),
        );
      }),
    );
  }
}
