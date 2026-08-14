import 'package:flutter/material.dart';

extension WidgetModifiers on Widget {
  Widget padding({
    double? all,
    double? vertical,
    double? horizontal,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: top ?? vertical ?? all ?? 0,
        bottom: bottom ?? vertical ?? all ?? 0,
        left: left ?? horizontal ?? all ?? 0,
        right: right ?? horizontal ?? all ?? 0,
      ),
      child: this,
    );
  }

  Widget center() {
    return Center(child: this);
  }

  Widget expanded() {
    return Expanded(child: this);
  }
}
