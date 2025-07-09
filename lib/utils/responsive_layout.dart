import 'package:flutter/material.dart';

enum ScreenSize { phone, tablet, desktop, fourK }

class ResponsiveLayout {
  // Breakpoints
  static const double phoneMaxWidth = 600;
  static const double tabletMaxWidth = 1024;
  static const double desktopMaxWidth = 1440;
  // 4K starts above desktop

  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width <= phoneMaxWidth) {
      return ScreenSize.phone;
    } else if (width <= tabletMaxWidth) {
      return ScreenSize.tablet;
    } else if (width <= desktopMaxWidth) {
      return ScreenSize.desktop;
    } else {
      return ScreenSize.fourK;
    }
  }

  static bool isPhone(BuildContext context) => getScreenSize(context) == ScreenSize.phone;
  static bool isTablet(BuildContext context) => getScreenSize(context) == ScreenSize.tablet;
  static bool isDesktop(BuildContext context) => getScreenSize(context) == ScreenSize.desktop;
  static bool isFourK(BuildContext context) => getScreenSize(context) == ScreenSize.fourK;

  // Responsive values
  static T responsive<T>(
    BuildContext context, {
    required T phone,
    T? tablet,
    T? desktop,
    T? fourK,
  }) {
    switch (getScreenSize(context)) {
      case ScreenSize.phone:
        return phone;
      case ScreenSize.tablet:
        return tablet ?? phone;
      case ScreenSize.desktop:
        return desktop ?? tablet ?? phone;
      case ScreenSize.fourK:
        return fourK ?? desktop ?? tablet ?? phone;
    }
  }

  // Grid column counts for different screen sizes
  static int getAttributeGridColumns(BuildContext context) {
    return responsive(
      context,
      phone: 3,      // 3 columns on phone (current)
      tablet: 4,     // 4 columns on tablet 
      desktop: 6,    // 6 columns on desktop
      fourK: 8,      // 8 columns on 4K
    );
  }

  // Content max width to prevent over-stretching
  static double getContentMaxWidth(BuildContext context) {
    return responsive(
      context,
      phone: double.infinity,  // Full width on phone
      tablet: 800,            // Constrained on tablet
      desktop: 1200,          // Larger constraint on desktop
      fourK: 1600,            // Even larger on 4K
    );
  }

  // Padding values
  static EdgeInsets getPagePadding(BuildContext context) {
    return EdgeInsets.all(responsive(
      context,
      phone: 16.0,
      tablet: 24.0,
      desktop: 32.0,
      fourK: 48.0,
    ));
  }

  // Card spacing
  static double getCardSpacing(BuildContext context) {
    return responsive(
      context,
      phone: 16.0,
      tablet: 20.0,
      desktop: 24.0,
      fourK: 32.0,
    );
  }
}
