import 'package:flutter/material.dart';

class OverlayPainter extends CustomPainter {
  final double screenWidth;
  final double screenHeight;
  final double rectWidth;
  final double rectHeight;

  OverlayPainter({
    required this.screenWidth,
    required this.screenHeight,
    required this.rectWidth,
    required this.rectHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = screenWidth / 2;
    final double centerY = screenHeight / 2.1;

    // Define the rectangular cutout
    final Rect holeRect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: rectWidth,
      height: rectHeight,
    );

    // Define the outer path (full-screen dark overlay)
    final Path outerPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, screenWidth, screenHeight));

    // Define the cutout path (rectangle)
    final Path cutoutPath = Path()..addRect(holeRect);

    // Subtract the cutout from the overlay
    final Path overlayPath =
        Path.combine(PathOperation.difference, outerPath, cutoutPath);

    // Paint overlay
    final Paint overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Paint the border of the rectangle
    final Paint borderPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw the dark overlay with the transparent cutout
    canvas.drawPath(overlayPath, overlayPaint);

    // Draw the border around the cutout
    canvas.drawRect(holeRect, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
