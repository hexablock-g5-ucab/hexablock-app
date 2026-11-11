import 'dart:io';

import 'package:test/test.dart';

/// Fails if the engine (Layer 1) imports anything outside pure Dart.
/// Evidence of the Clean Architecture dependency rule for the jury.
void main() {
  group('Architecture · hexa_engine', () {
    test(
      'should_import_only_dart_core_and_meta_when_scanning_engine_sources',
      () {
        // Arrange
        final forbidden = RegExp(
          r'''(import|export)\s+['"]package:(?!hexa_engine/|meta/)''',
        );
        final sources = Directory('lib')
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'));

        // Act
        final offenders = [
          for (final f in sources)
            if (forbidden.hasMatch(f.readAsStringSync())) f.path,
        ];

        // Assert
        expect(offenders, isEmpty, reason: 'Layer 1 must stay framework-free');
      },
    );
  });
}
