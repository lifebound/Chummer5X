import 'package:flutter/material.dart';
import '../utils/responsive_layout.dart';

class ScreenSizeIndicator extends StatelessWidget {
  const ScreenSizeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveLayout.getScreenSize(context);
    final width = MediaQuery.of(context).size.width;
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${screenSize.name.toUpperCase()} (${width.toInt()}px)',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
