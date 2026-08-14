import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';

/// Prévia ilustrativa de mapa — substitui o `GoogleMap` real (que exige uma
/// API key configurada para renderizar) por um placeholder estático, só
/// para dar noção de localização enquanto a integração não é reativada.
class MockMapPreview extends StatelessWidget {
  const MockMapPreview({super.key, required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 180,
        width: double.infinity,
        color: AppColor.primarySoft,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.map_outlined,
              size: 36,
              color: AppColor.primaryDark,
            ),
            const SizedBox(height: 8),
            Text(
              address,
              textAlign: TextAlign.center,
              style: AppTextStyle.captionStyle.copyWith(
                color: AppColor.primaryDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Mapa ilustrativo',
              style: AppTextStyle.captionStyle.copyWith(
                color: AppColor.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
