import 'package:flutter/material.dart';

class Heart extends StatelessWidget {
  const Heart({
    super.key,
    required HeartPainter painter,
    Size? size,
  })  : _painter = painter,
        _size = size;

  final HeartPainter _painter;
  final Size? _size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      size: _size ?? Size.zero,
    );
  }

  const Heart.filled({
    super.key,
    Size? size,
  })  : _painter = const FilledHeartPainter(),
        _size = size;

  Heart.unfilled({
    super.key,
    Size? size,
    double strokeWidth = 5,
  })  : _painter = HeartPainter(stockWidth: strokeWidth),
        _size = size;

  const Heart.gradient({
    super.key,
    Size? size,
  })  : _painter = const GradientHeartPainter(),
        _size = size;
}

class HeartPainter extends CustomPainter {
  const HeartPainter({this.stockWidth = 5});

  final double stockWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stockWidth;

    final path = HeartPainter.createHeartShapePath(size);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  static Path createHeartShapePath(Size size) {
    return Path()
      ..moveTo(size.width / 2, size.height * 0.35)
      ..cubicTo(0.2 * size.width, size.height * 0.1, -0.25 * size.width,
          size.height * 0.6, 0.5 * size.width, size.height)
      ..cubicTo(1.25 * size.width, size.height * 0.6, 0.8 * size.width,
          size.height * 0.1, size.width / 2, size.height * 0.35)
      ..close();
  }
}

class FilledHeartPainter extends HeartPainter {
  const FilledHeartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red;
    final path = HeartPainter.createHeartShapePath(size);

    canvas.drawPath(path, paint);
  }
}

class GradientHeartPainter extends HeartPainter {
  const GradientHeartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = const LinearGradient(
        colors: [Colors.red, Colors.purple],
        stops: [0.2, 1],
        transform: GradientRotation(0.3 * 3.14),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = HeartPainter.createHeartShapePath(size);

    canvas.drawPath(path, paint);
  }
}
