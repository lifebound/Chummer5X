import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  /// Pick a Chummer XML file from the device
  static Future<String?> pickChumerFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xml', 'chum5'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        return result.files.single.path!;
      }
      return null;
    } catch (e) {
      debugPrint('Error picking file: $e');

      return null;
    }
  }
  
  /// Get the documents directory for saving/loading files
  static Future<String> getDocumentsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  
  /// Get the temporary directory for caching
  static Future<String> getTempDirectory() async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }
  
  /// Save character data to a local file
  static Future<bool> saveCharacterToCache(String fileName, String xmlContent) async {
    try {
      final tempDir = await getTempDirectory();
      final file = File('$tempDir/$fileName');
      await file.writeAsString(xmlContent);
      return true;
    } catch (e) {
      debugPrint('Error saving file: $e');
      return false;
    }
  }
  
  /// Read character data from cache
  static Future<String?> readCharacterFromCache(String fileName) async {
    try {
      final tempDir = await getTempDirectory();
      final file = File('$tempDir/$fileName');
      
      if (await file.exists()) {
        return await file.readAsString();
      }
      return null;
    } catch (e) {
      debugPrint('Error reading cached file: $e');
      return null;
    }
  }
  
  /// List all cached character files
  static Future<List<String>> getCachedCharacterFiles() async {
    try {
      final tempDir = await getTempDirectory();
      final directory = Directory(tempDir);
      final files = await directory.list().toList();
      
      return files
          .whereType<File>()
          .where((file) => file.path.endsWith('.xml') || file.path.endsWith('.chum5'))
          .map((file) => file.path.split('/').last)
          .toList();
    } catch (e) {
      debugPrint('Error listing cached files: $e');
      return [];
    }
  }
  
  /// Delete a cached character file
  static Future<bool> deleteCachedCharacter(String fileName) async {
    try {
      final tempDir = await getTempDirectory();
      final file = File('$tempDir/$fileName');
      
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting cached file: $e');
      return false;
    }
  }
}
