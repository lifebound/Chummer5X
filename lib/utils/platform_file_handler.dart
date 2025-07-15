import 'dart:io';
import 'package:flutter/foundation.dart';

/// Abstract interface for platform-specific file operations
abstract class FileHandler {
  Future<bool> canWriteToFile(String path);
  Future<void> writeXmlToFile(String path, String xmlContent);
  Future<String> exportXmlForSharing(String xmlContent, String filename);
}

/// Factory to create appropriate file handler for current platform
class PlatformFileHandler {
  static FileHandler create() {
    if (kIsWeb) {
      return WebFileHandler();
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return DesktopFileHandler();
    } else if (Platform.isAndroid || Platform.isIOS) {
      return MobileFileHandler();
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }
}

/// Desktop file handler with direct file system access
class DesktopFileHandler implements FileHandler {
  @override
  Future<bool> canWriteToFile(String path) async {
    try {
      final file = File(path);
      final parent = file.parent;
      
      // Ensure parent directory exists
      await parent.create(recursive: true);
      
      // Try to create a temporary file to test write permissions
      final tempFile = File('${path}_temp_write_test');
      await tempFile.writeAsString('test');
      await tempFile.delete();
      
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> writeXmlToFile(String path, String xmlContent) async {
    final file = File(path);
    // Ensure parent directory exists
    await file.parent.create(recursive: true);
    await file.writeAsString(xmlContent);
  }

  @override
  Future<String> exportXmlForSharing(String xmlContent, String filename) async {
    // For desktop, we can save directly to Downloads or let user choose location
    final downloadsPath = _getDownloadsPath();
    final filePath = '$downloadsPath/$filename';
    await writeXmlToFile(filePath, xmlContent);
    return filePath;
  }

  String _getDownloadsPath() {
    if (Platform.isWindows) {
      return '${Platform.environment['USERPROFILE']}\\Downloads';
    } else {
      return '${Platform.environment['HOME']}/Downloads';
    }
  }
}

/// Mobile file handler with limited file system access
class MobileFileHandler implements FileHandler {
  @override
  Future<bool> canWriteToFile(String path) async {
    // Mobile platforms have restricted file access
    // Generally can't write to arbitrary paths
    return false;
  }

  @override
  Future<void> writeXmlToFile(String path, String xmlContent) async {
    throw UnsupportedError('Direct file writing not supported on mobile platforms');
  }

  @override
  Future<String> exportXmlForSharing(String xmlContent, String filename) async {
    // On mobile, we would use the share_plus package to share the file
    // For now, return a placeholder path indicating sharing should be used
    return 'share://$filename';
  }
}

/// Web file handler with browser download capabilities
class WebFileHandler implements FileHandler {
  @override
  Future<bool> canWriteToFile(String path) async {
    // Web can't write to arbitrary file paths
    return false;
  }

  @override
  Future<void> writeXmlToFile(String path, String xmlContent) async {
    throw UnsupportedError('Direct file writing not supported on web platform');
  }

  @override
  Future<String> exportXmlForSharing(String xmlContent, String filename) async {
    // On web, we would trigger a download
    // For now, return a placeholder indicating download should be triggered
    return 'download://$filename';
  }
}
