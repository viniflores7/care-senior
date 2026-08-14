import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_color.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.name,
    this.radius = 24,
    this.photoPath,
  });

  final String name;
  final double radius;
  final String? photoPath;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final photoPath = this.photoPath;

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColor.primary,
      backgroundImage: photoPath == null
          ? null
          : (kIsWeb ? NetworkImage(photoPath) : FileImage(File(photoPath)))
                as ImageProvider,
      child: photoPath != null
          ? null
          : Text(
              _initials,
              style: TextStyle(
                color: AppColor.white,
                fontWeight: FontWeight.w700,
                fontSize: radius * 0.7,
              ),
            ),
    );
  }
}
