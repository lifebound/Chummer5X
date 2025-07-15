import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/utils/platform_file_handler.dart';
import 'dart:io';

void main() {
  group('PlatformFileHandler', () {
    test('should create appropriate handler for current platform', () {
      final handler = PlatformFileHandler.create();
      
      expect(handler, isNotNull);
      
      // Can't test platform-specific behavior in unit tests easily,
      // but we can verify the factory creates something
      expect(handler, isA<FileHandler>());
    });
  });

  group('DesktopFileHandler', () {
    late DesktopFileHandler handler;
    late String testFilePath;

    setUp(() {
      handler = DesktopFileHandler();
      testFilePath = 'test/fixtures/test_output.xml';
    });

    tearDown(() {
      final file = File(testFilePath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    test('should write XML to file', () async {
      const xmlContent = '<?xml version="1.0"?><test>content</test>';
      
      await handler.writeXmlToFile(testFilePath, xmlContent);
      
      final file = File(testFilePath);
      expect(file.existsSync(), true);
      
      final content = await file.readAsString();
      expect(content, xmlContent);
    });

    test('should check if file can be written', () async {
      final canWrite = await handler.canWriteToFile(testFilePath);
      expect(canWrite, true);
    });

    test('should handle export for sharing', () async {
      const xmlContent = '<?xml version="1.0"?><test>export</test>';
      const filename = 'exported_character.xml';
      
      final result = await handler.exportXmlForSharing(xmlContent, filename);
      
      expect(result, isNotNull);
      expect(result, contains(filename));
    });
  }, skip: !(Platform.isWindows || Platform.isMacOS || Platform.isLinux));

  group('MobileFileHandler', () {
    late MobileFileHandler handler;

    setUp(() {
      handler = MobileFileHandler();
    });

    test('should not support direct file writing', () async {
      final canWrite = await handler.canWriteToFile('/some/path');
      expect(canWrite, false);
    });

    test('should throw error when trying to write file', () async {
      expect(
        () => handler.writeXmlToFile('/some/path', 'content'),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('should return share path for export', () async {
      const filename = 'character.xml';
      final result = await handler.exportXmlForSharing('content', filename);
      
      expect(result, startsWith('share://'));
      expect(result, contains(filename));
    });
  });

  group('WebFileHandler', () {
    late WebFileHandler handler;

    setUp(() {
      handler = WebFileHandler();
    });

    test('should not support direct file writing', () async {
      final canWrite = await handler.canWriteToFile('/some/path');
      expect(canWrite, false);
    });

    test('should throw error when trying to write file', () async {
      expect(
        () => handler.writeXmlToFile('/some/path', 'content'),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('should return download path for export', () async {
      const filename = 'character.xml';
      final result = await handler.exportXmlForSharing('content', filename);
      
      expect(result, startsWith('download://'));
      expect(result, contains(filename));
    });
  });
}
