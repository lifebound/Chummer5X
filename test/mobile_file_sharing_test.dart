import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/utils/platform_file_handler.dart';

void main() {
  group('Platform File Handler Tests', () {
    test('should create appropriate file handler for current platform', () {
      final handler = PlatformFileHandler.create();
      expect(handler, isNotNull);
      expect(handler, isA<FileHandler>());
    });

    test('mobile file handler should not support direct file writing', () async {
      final handler = MobileFileHandler();
      final canWrite = await handler.canWriteToFile('/some/path');
      expect(canWrite, false);
      
      expect(
        () => handler.writeXmlToFile('/some/path', '<xml>test</xml>'),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('mobile file handler should handle export for sharing', () async {
      final handler = MobileFileHandler();
      
      // This test would require mocking share_plus and path_provider
      // For now, we just verify the method exists and doesn't throw immediately
      expect(
        () => handler.exportXmlForSharing('<xml>test</xml>', 'test.xml'),
        returnsNormally,
      );
    });
  });
}
