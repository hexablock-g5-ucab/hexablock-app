import 'package:hexa_application/hexa_application.dart';
import 'package:test/test.dart';

void main() {
  group('NFR-006 · use-case logging', () {
    test('should_return_original_result_when_operation_succeeds', () async {
      // Arrange
      final logger = _RecordingLogger();
      const expected = Success<String, AppFailure>('private result');
      final received = <String>[];
      final operation = LoggingUseCase(
        'lookup',
        _Operation((input) async {
          received.add(input);
          return expected;
        }),
        logger,
      );

      // Act
      final result = await operation.execute('private input');

      // Assert
      expect(result, same(expected));
      expect(received, ['private input']);
      expect(logger.messages, [
        'lookup started',
        matches(RegExp(r'^lookup succeeded in \d+ ms$')),
      ]);
    });

    test('should_return_original_failure_when_operation_is_rejected', () async {
      // Arrange
      const expected = Failure<String, AppFailure>(
        AppFailure(FailureKind.unavailable),
      );
      final logger = _RecordingLogger();
      final operation = LoggingUseCase(
        'lookup',
        _Operation((_) async => expected),
        logger,
      );

      // Act
      final result = await operation.execute('private input');

      // Assert
      expect(result, same(expected));
      expect(logger.errorType, isNull);
      expect(logger.messages, [
        'lookup started',
        matches(RegExp(r'^lookup failed in \d+ ms$')),
      ]);
    });

    test('should_rethrow_original_error_when_operation_throws', () async {
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

    test('should_preserve_all_outcomes_when_logger_throws', () async {
      // Arrange
      final logger = _BrokenLogger();
      const ok = Success<String, AppFailure>('ok');
      const unavailable = Failure<String, AppFailure>(
        AppFailure(FailureKind.unavailable),
      );
      final failure = StateError('operation failed');
      final success = LoggingUseCase(
        'read',
        _Operation((_) async => ok),
        logger,
      );
      final failed = LoggingUseCase(
        'read',
        _Operation((_) async => unavailable),
        logger,
      );
      final rejected = LoggingUseCase(
        'read',
        _Operation((_) => throw failure),
        logger,
      );

      // Act
      final result = await success.execute('');
      final returnedFailure = await failed.execute('');
      final pending = rejected.execute('');

      // Assert
      expect(result, same(ok));
      expect(returnedFailure, same(unavailable));
      await expectLater(pending, throwsA(same(failure)));
    });
  });
}

final class _Operation implements UseCase<String, String> {
  const _Operation(this.run);
  final Future<Result<String, AppFailure>> Function(String) run;
  @override
  Future<Result<String, AppFailure>> execute(String input) => run(input);
}

final class _RecordingLogger implements ILogger {
  final messages = <String>[];
  Type? errorType;

  @override
  void info(String message) => messages.add(message);

  @override
  void error(String message, Type errorType, StackTrace stackTrace) {
    this.errorType = errorType;
    messages.add(message);
  }
}

final class _BrokenLogger implements ILogger {
  @override
  void info(String message) => throw StateError('unavailable');
  @override
  void error(String message, Type errorType, StackTrace stackTrace) =>
      throw StateError('unavailable');
}
