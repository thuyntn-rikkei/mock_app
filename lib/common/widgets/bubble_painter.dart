import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//Copy this CustomPainter code to the Bottom of the File
class BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xffCEE1FF).withOpacity(1.0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 12.h, size.width, size.height - 12.h),
        bottomRight: const Radius.circular(6),
        bottomLeft: const Radius.circular(6),
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
      ),
      paint0Fill,
    );

    Path path_1 = Path();
    path_1.moveTo(24.w, 12.h);
    path_1.lineTo(36.w, 0);
    path_1.lineTo(48.w, 12.h);
    path_1.lineTo(24.w, 12.h);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = const Color(0xffCEE1FF).withOpacity(1.0);
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
