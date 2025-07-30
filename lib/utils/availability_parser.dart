import 'package:flutter/widgets.dart';
import 'package:xml/xml.dart';

String parseAvail(XmlElement? element, int itemRating) {
  final String rawAvail = element?.innerText.trim() ?? '';

  if (rawAvail.isEmpty) {
    return '';
  }

  // Regex to match well-formatted availability: "number" or "-", optionally followed by R or F.
  // Group 1: number or dash
  // Group 2: R or F (optional)
  final RegExp wellFormattedRegex = RegExp(r'^(\d+|-)([RF]?)$');
  final RegExp calculationRegex = RegExp(r'^(\d+)([RF]?)$'); // Matches just number and optional suffix

  if (wellFormattedRegex.hasMatch(rawAvail)) {
    // If it's already well-formatted, return as is.
    return rawAvail;
  } else if (calculationRegex.hasMatch(rawAvail)) {
    // If it's not well-formatted but matches the calculation pattern (e.g., "500", "10F")
    final Match match = calculationRegex.firstMatch(rawAvail)!;
    final String numberPart = match.group(1)!;
    final String suffix = match.group(2)!;

    try {
      final int baseValue = int.parse(numberPart);
      final int calculatedValue = baseValue * itemRating;
      return '$calculatedValue$suffix';
    } catch (e) {
      // Fallback if parsing fails for some reason (e.g., non-numeric string despite regex match attempt)
      debugPrint('Warning: Could not parse availability "$rawAvail" with rating $itemRating. Error: $e');
      return rawAvail; // Return original if calculation fails
    }
  }

  // If it doesn't match either expected pattern, return original or default.
  debugPrint('Warning: Unrecognized availability format: "$rawAvail"');
  return rawAvail;
}

// Re-using the generic XML text parser for other fields
String parseXmlElementText(XmlElement? element, {String defaultValue = ''}) {
  return element?.innerText ?? defaultValue;
}