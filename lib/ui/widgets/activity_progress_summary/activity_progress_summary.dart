import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_motion.dart';
import 'package:care_senior_study/style/app_text_style.dart';

/// Resumo animado de quantas atividades já foram concluídas hoje — é o
/// reforço visual pra quem acompanha de fora (o responsável) se sentir
/// seguro sobre o que já foi feito.
class ActivityProgressSummary extends StatelessWidget {
  const ActivityProgressSummary({
    super.key,
    required this.completed,
    required this.total,
    this.label = 'Atividades de hoje',
  });

  final int completed;
  final int total;
  final String label;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : completed / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyle.subtitleStyle),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: progress),
                    duration: AppMotion.medium,
                    curve: AppMotion.curve,
                    builder: (context, value, child) {
                      return LinearProgressIndicator(
                        value: value,
                        minHeight: 8,
                        backgroundColor: AppColor.greyMedium,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColor.success,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '$completed/$total',
            style: AppTextStyle.titleStyle.copyWith(
              color: AppColor.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
