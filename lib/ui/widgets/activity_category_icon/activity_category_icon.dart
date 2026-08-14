import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:care_senior_study/data/models/activity_type.dart';

/// Ícone associado a cada categoria de atividade — usa os SVGs próprios do
/// app quando existem (medicação, refeição, confraternização) e cai para
/// `Icons.*` do Material nas demais categorias.
class ActivityCategoryIcon extends StatelessWidget {
  const ActivityCategoryIcon({
    super.key,
    required this.type,
    required this.color,
    this.size = 20,
  });

  final String type;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorFilter = ColorFilter.mode(color, BlendMode.srcIn);

    return switch (type) {
      ActivityType.medication => SvgPicture.asset(
        'assets/icons/medication.svg',
        width: size,
        height: size,
        colorFilter: colorFilter,
      ),
      ActivityType.meal => SvgPicture.asset(
        'assets/icons/kitchen.svg',
        width: size,
        height: size,
        colorFilter: colorFilter,
      ),
      ActivityType.socialGathering => SvgPicture.asset(
        'assets/icons/people.svg',
        width: size,
        height: size,
        colorFilter: colorFilter,
      ),
      ActivityType.physicalActivity => Icon(
        Icons.directions_walk,
        size: size,
        color: color,
      ),
      ActivityType.vitalSigns => Icon(
        Icons.monitor_heart_outlined,
        size: size,
        color: color,
      ),
      ActivityType.hygiene => Icon(
        Icons.clean_hands_outlined,
        size: size,
        color: color,
      ),
      ActivityType.sleep => Icon(
        Icons.bedtime_outlined,
        size: size,
        color: color,
      ),
      _ => Icon(Icons.more_horiz, size: size, color: color),
    };
  }
}
