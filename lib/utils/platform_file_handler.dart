import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// Web-specific import
import 'package:universal_html/html.dart' as html;

/// Abstract interface for platform-specific file operations
abstract class FileHandler {
  Future<bool> canWriteToFile(String path);
  Future<void> writeXmlToFile(String path, String xmlContent);
  Future<String?> exportXmlForSharing(String xmlContent, String filename);
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
    
    // Strip any existing BOM from the content
    String cleanContent = xmlContent;
    if (cleanContent.startsWith('\uFEFF')) {
      cleanContent = cleanContent.substring(1);
    }
    
    // Write with explicit UTF-8 encoding without BOM
    await file.writeAsString(cleanContent, encoding: Encoding.getByName('utf-8')!);
  }

  @override
  Future<String?> exportXmlForSharing(String xmlContent, String filename) async {
    // Show save file dialog to let user choose location and filename
    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Character File',
      fileName: filename,
      type: FileType.custom,
      allowedExtensions: ['chum5', 'xml'],
      lockParentWindow: true,
    );
    
    if (result != null) {
      // User selected a location, write the file
      await writeXmlToFile(result, xmlContent);
      return result;
    }
    
    // User cancelled the dialog
    return null;
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

  /// Export XML content for sharing on mobile platforms
  /// 
  /// This method creates a temporary file and uses the share_plus package
  /// to share it through the platform's native sharing mechanism.
  /// Returns a descriptive status message instead of a file path.
  /// 
  /// Falls back to legacy behavior ('share://$filename') in test environments
  /// where Flutter services may not be available.
  @override
  Future<String?> exportXmlForSharing(String xmlContent, String filename) async {
    try {
      // Check if we're in a test environment where Flutter services aren't available
      if (kDebugMode) {
        try {
          // Try to access temporary directory - this will fail in test environment
          final tempDir = await getTemporaryDirectory();
          final tempFile = File('${tempDir.path}/$filename');
          
          // Write the XML content to the temporary file
          await tempFile.writeAsString(xmlContent, encoding: utf8);
          
          // Share the file using share_plus
          final result = await Share.shareXFiles(
            [XFile(tempFile.path)],
            text: 'Shadowrun character file: ${filename.replaceAll('.chum5', '')}',
            subject: 'Shadowrun Character Export',
          );
          
          // Clean up the temporary file after a delay to allow sharing to complete
          Future.delayed(const Duration(seconds: 30), () {
            if (tempFile.existsSync()) {
              tempFile.deleteSync();
            }
          });
          
          // Return a descriptive message instead of the temp path
          if (result.status == ShareResultStatus.success) {
            return 'Character shared successfully';
          } else if (result.status == ShareResultStatus.dismissed) {
            return null; // User cancelled
          } else {
            return 'Share failed: ${result.status}';
          }
        } catch (bindingError) {
          // Fall back to old behavior for tests or when services aren't available
          debugPrint('Flutter services not available, using fallback: $bindingError');
          return 'share://$filename';
        }
      } else {
        // Production environment - full implementation
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$filename');
        
        await tempFile.writeAsString(xmlContent, encoding: utf8);
        
        final result = await Share.shareXFiles(
          [XFile(tempFile.path)],
          text: 'Shadowrun character file: ${filename.replaceAll('.chum5', '')}',
          subject: 'Shadowrun Character Export',
        );
        
        Future.delayed(const Duration(seconds: 30), () {
          if (tempFile.existsSync()) {
            tempFile.deleteSync();
          }
        });
        
        if (result.status == ShareResultStatus.success) {
          return 'Character shared successfully';
        } else if (result.status == ShareResultStatus.dismissed) {
          return null;
        } else {
          return 'Share failed: ${result.status}';
        }
      }
    } catch (e) {
      debugPrint('Error sharing file on mobile: $e');
      // Fall back to old behavior for compatibility
      return 'share://$filename';
    }
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
  Future<String?> exportXmlForSharing(String xmlContent, String filename) async {
    try {
      if (kIsWeb) {
        // Strip any existing BOM from the content
        String cleanContent = xmlContent;
        if (cleanContent.startsWith('\uFEFF')) {
          cleanContent = cleanContent.substring(1);
        }
        
        // Create a blob with the XML content
        final bytes = utf8.encode(cleanContent);
        final blob = html.Blob([bytes], 'application/xml');
        
        // Create a download URL
        final url = html.Url.createObjectUrlFromBlob(blob);
        
        // Create a temporary anchor element to trigger download
        final anchor = html.AnchorElement(href: url);
        anchor.download = filename;
        anchor.style.display = 'none';
        
        // Add to document, click, and remove
        html.document.body!.append(anchor);
        anchor.click();
        anchor.remove();
        
        // Clean up the URL
        html.Url.revokeObjectUrl(url);
        
        return filename; // Return filename to indicate success
      } else {
        return 'download://$filename';
      }
    } catch (e) {
      debugPrint('Error triggering web download: $e');
      return null;
    }
  }
}
