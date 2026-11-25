import '../ports/logger.dart';
import '../use_cases/result.dart';
import '../use_cases/use_case.dart';

/// Logs a fixed operation name, outcome and elapsed time around a use case.
/// Supply a developer-defined name independent of the request.
final class LoggingUseCase<I, O> implements UseCase<I, O> {
  const LoggingUseCase(this.name, this.inner, this.logger);

  final String name;
  final UseCase<I, O> inner;
  final ILogger logger;

  @override
  Future<Result<O, AppFailure>> execute(I input) async {
    _tryLog(() => logger.info('$name started'));
    final timer = Stopwatch()..start();
    try {
      final result = await inner.execute(input);
      timer.stop();
      final outcome = switch (result) {
        Success() => 'succeeded',
        Failure() => 'failed',
      };
      _tryLog(
        () => logger.info('$name $outcome in ${timer.elapsedMilliseconds} ms'),
      );
      return result;
    } catch (error, stackTrace) {
      timer.stop();
      // Exception messages can contain player input. Log only the error type.
      _tryLog(
        () => logger.error(
          '$name failed in ${timer.elapsedMilliseconds} ms',
          error.runtimeType,
          stackTrace,
        ),
      );
      rethrow;
    }
  }

  void _tryLog(void Function() write) {
    try {
      write();
    } catch (_) {
      // Diagnostic failures must not mask the outcome of a game operation.
    }
  }
}
