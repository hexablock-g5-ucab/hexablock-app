import 'package:hexa_application/hexa_application.dart';
import 'package:test/test.dart';

void main() {
  group('NFR-006 · use-case logging', () {
    test('should_return_original_result_when_operation_succeeds', () async {
      // Arrange
      final logger = _RecordingLogger();
      final received = <String>[];
      final operation = LoggingUseCase(
        'lookup',
        _Operation((input) async {
          received.add(input);
          return 'private result';
        }),
        logger,
      );

      // Act
      final result = await operation.execute('private input');

      // Assert
      expect(result, 'private result');
      expect(received, ['private input']);
      expect(logger.messages, [
        'lookup started',
        matches(RegExp(r'^lookup succeeded in \d+ ms$')),
      ]);
    });

    test('should_rethrow_original_error_when_operation_fails', () async {
      // Arrange
      final logger = _RecordingLogger();
      final failure = StateError('private token');
      final operation = LoggingUseCase(
        'lookup',
        _Operation((_) async => throw failure),
        logger,
      );

      // Act
      final pending = operation.execute('private input');

      // Assert
      await expectLater(pending, throwsA(same(failure)));
      expect(logger.errorType, StateError);
      expect(logger.messages, [
        'lookup started',
        matches(RegExp(r'^lookup failed in \d+ ms$')),
      ]);
    });

    test('should_preserve_both_outcomes_when_logger_throws', () async {
      // Arrange
      final logger = _BrokenLogger();
      final failure = StateError('operation failed');
      final success = LoggingUseCase(
        'read',
        _Operation((_) async => 'ok'),
        logger,
      );
      final rejected = LoggingUseCase(
        'read',
        _Operation((_) => throw failure),
        logger,
      );

      // Act
      final result = await success.execute('');
      final pending = rejected.execute('');

      // Assert
      expect(result, 'ok');
      await expectLater(pending, throwsA(same(failure)));
    });
  });
}

final class _Operation implements UseCase<String, String> {
  const _Operation(this.run);
  final Future<String> Function(String) run;
  @override
  Future<String> execute(String input) => run(input);
}

final class _RecordingLogger implements ILogger {
  final messages = <String>[];
  Object? errorType;

  @override
  void info(String message) => messages.add(message);

  @override
  void error(String message, Object error, StackTrace stackTrace) {
    errorType = error;
    messages.add(message);
  }
}

final class _BrokenLogger implements ILogger {
  @override
  void info(String message) => throw StateError('unavailable');
  @override
  void error(String message, Object error, StackTrace stackTrace) =>
      throw StateError('unavailable');
}
