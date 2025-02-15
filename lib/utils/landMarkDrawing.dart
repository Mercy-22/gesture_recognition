import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class LandmarkPainter extends CustomPainter {
  final ui.Image image;
  final List<Map<String, double>> landmarks;

  LandmarkPainter({required this.image, required this.landmarks});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the image
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(0, 0, size.width, size.height),
      image: image,
    );

    // Define paint for landmarks
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5.0
      ..style = PaintingStyle.fill;

    // Draw landmarks
    for (var landmark in landmarks) {
      double x = landmark["x"]! * size.width;  // Denormalize x
      double y = landmark["y"]! * size.height; // Denormalize y
      canvas.drawCircle(Offset(x, y), 5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
