import 'package:flutter/material.dart';

import '../../../../core/utils/DB/models/draw_path.dart';

class PlanPainter extends CustomPainter {
  final List<DrawPath> paths;

  PlanPainter(this.paths);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in paths) {
      final paint = Paint()
        ..color = p.color
        ..strokeWidth = p.strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(p.path, paint);

    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
