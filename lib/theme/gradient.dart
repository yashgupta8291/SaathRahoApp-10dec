import 'dart:math';
import 'package:flutter/material.dart';

class BackgroundShapes extends StatelessWidget {
  const BackgroundShapes({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox.expand(
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              // White background layer
              Positioned.fill(
                child: Container(
                  color: Colors.white,
                ),
              ),
              // Generate multiple randomly placed images
              ..._generateRandomImages(
                  40), // You can adjust the number of images
              // Child widget goes on top of the background layers
              Positioned.fill(child: child),
            ],
          ),
        ),
      ),
    );
  }

  // Function to generate n Positioned widgets with images at random positions
  List<Widget> _generateRandomImages(int count) {
    final Random random = Random();
    List<Widget> images = [];

    for (int i = 0; i < count; i++) {
      double top = random.nextDouble() * 800; // Adjust this for Y range
      double left = random.nextDouble() * 800; // Adjust this for X range

      images.add(
        Positioned(
          top: top,
          left: left,
          child: Image.asset(
            "assets/images/house.png",
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return images;
  }
}
