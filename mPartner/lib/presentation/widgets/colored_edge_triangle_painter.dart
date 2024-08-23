import 'package:flutter/material.dart';

class ColoredEdgeTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.strokeWidth = 2.0;
    // Define the vertices of the triangle
    final List<Offset> vertices = [
      Offset(size.width / 2, 0),
      Offset(size.width, size.height),
      Offset(0, size.height),
    ];

    // Define the edge colors
    final List<Color> edgeColors = [
      Colors.grey,
      Colors.white,
      Colors.grey,
    ];

    for (int i = 0; i < vertices.length; i++) {
      paint.color = edgeColors[i];
      canvas.drawLine(vertices[i], vertices[(i + 1) % vertices.length], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
