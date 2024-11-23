import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class AppTheme {
  const AppTheme._();

  static final light = FlexThemeData.light(
    scheme: FlexScheme.deepBlue,
    appBarStyle: FlexAppBarStyle.material,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 10,
    appBarOpacity: 0.95,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
  );

  static Widget background(BuildContext context) {
    return Stack(
      children: [
        // Gradient Background
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFff9dc6), // Top color
                  Color(0xFFec5091), // Bottom color
                ],
              ),
            ),
          ),
        ),
        // Decorative circles - Layer 1
        Positioned(
          top: -80,
          left: -60,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF9F5F6).withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: -90,
          right: -70,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF9F5F6).withOpacity(0.1),
            ),
          ),
        ),
        // Decorative circles - Layer 2
        Positioned(
          top: 120,
          right: -40,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF9F5F6).withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: 200,
          left: -40,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF9F5F6).withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          right: 30,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF9F5F6).withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          top: 350,
          right: 100,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF9F5F6).withOpacity(0.1),
            ),
          ),
        ),
        // Decorative circles - Layer 3
        Positioned(
          top: 300,
          right: 40,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF9F5F6).withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: 80,
          left: 60,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF9F5F6).withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: 160,
          right: 110,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF9F5F6).withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          top: 125,
          left: 20,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF9F5F6).withOpacity(0.1),
            ),
          ),
        ),
      ],
    );
  }

  static Widget backgroundCalendar(BuildContext context) {
    return Stack(
      children: [
        // Gradient Background
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFf470a6), // Top color
                  Color(0xFFe21f6d), // Bottom color
                ],
              ),
            ),
          ),
        ),
        // Decorative circles - Layer 1
        Positioned(
          top: -80,
          left: -60,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF9F5F6).withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: -90,
          right: -70,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF9F5F6).withOpacity(0.1),
            ),
          ),
        ),
        // Decorative circles - Layer 2
        Positioned(
          top: 120,
          right: -40,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF9F5F6).withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: 200,
          left: -40,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF9F5F6).withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          right: 30,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF9F5F6).withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          top: 350,
          right: 100,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF9F5F6).withOpacity(0.1),
            ),
          ),
        ),
        // Decorative circles - Layer 3
        Positioned(
          top: 300,
          right: 40,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF9F5F6).withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: 80,
          left: 60,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF9F5F6).withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: 160,
          right: 110,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF9F5F6).withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          top: 125,
          left: 20,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF9F5F6).withOpacity(0.1),
            ),
          ),
        ),
      ],
    );
  }
}
