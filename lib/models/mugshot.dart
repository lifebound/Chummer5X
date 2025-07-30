import 'dart:convert';
import 'dart:typed_data';

/// Represents a character mugshot with image data and format detection
class Mugshot {
  final Uint8List imageData;
  final String imageFormat; // 'jpeg', 'png', 'gif'
  final String originalBase64;

  const Mugshot({
    required this.imageData,
    required this.imageFormat,
    required this.originalBase64,
  });

  /// Create a Mugshot from base64 string with automatic format detection
  factory Mugshot.fromBase64(String base64String) {
    try {
      // Decode the base64 string to bytes
      final imageData = base64Decode(base64String);
      
      // Detect image format based on magic bytes
      final format = _detectImageFormat(imageData);
      
      return Mugshot(
        imageData: imageData,
        imageFormat: format,
        originalBase64: base64String,
      );
    } catch (e) {
      throw ArgumentError('Invalid base64 image data: $e');
    }
  }

  /// Detect image format based on magic bytes (file signatures)
  static String _detectImageFormat(Uint8List bytes) {
    if (bytes.length < 4) {
      throw ArgumentError('Image data too short to determine format');
    }

    // JPEG magic bytes: FF D8 FF
    if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
      return 'jpeg';
    }

    // PNG magic bytes: 89 50 4E 47 0D 0A 1A 0A
    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A) {
      return 'png';
    }

    // GIF magic bytes: 47 49 46 38 (GIF8)
    if (bytes.length >= 6 &&
        bytes[0] == 0x47 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x38 &&
        (bytes[4] == 0x37 || bytes[4] == 0x39) && // 7 or 9
        bytes[5] == 0x61) { // 'a'
      return 'gif';
    }

    // Default to unknown format
    throw ArgumentError('Unsupported image format - only JPEG, PNG, and GIF are supported');
  }

  /// Get the MIME type for the image format
  String get mimeType {
    switch (imageFormat) {
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      default:
        return 'application/octet-stream';
    }
  }

  /// Check if the image format supports animation (only GIF)
  bool get isAnimated => imageFormat == 'gif';

  @override
  String toString() {
    return 'Mugshot(format: $imageFormat, size: ${imageData.length} bytes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Mugshot) return false;
    return originalBase64 == other.originalBase64;
  }

  @override
  int get hashCode => originalBase64.hashCode;
}
