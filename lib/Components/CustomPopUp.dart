import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PremiumPopup extends StatelessWidget {
  const PremiumPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main popup container
        Center(
          child: Container(
            width: 300,
            height: 60,
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 35),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black38,
                    blurRadius: 10,
                    blurStyle: BlurStyle.solid,
                    spreadRadius: BorderSide.strokeAlignCenter,
                    offset: Offset(3, 3))
              ],
              color: const Color(0xFFFEF9C3), // Light yellow color
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Want to list more?',
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'Upgrade To Premium Plan Now!',
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 12.2,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Triangle pointer
        Positioned(
          top: 40,
          left: 0,
          right: 13.5,
          child: Center(
            child: CustomPaint(
              size: Size(100, 40), // Width and height of the triangle
              painter: TrianglePainter(),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom painter to draw a triangle pointing downwards
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFFEF9C3) // Same color as the popup
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0) // Top left point
      ..lineTo(size.width / 2, size.height) // Bottom center point
      ..lineTo(size.width, 0) // Top right point
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; // No need to repaint
  }
}
