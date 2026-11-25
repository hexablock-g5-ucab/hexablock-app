/// An operation that completed with a value or an expected failure.
sealed class Result<T, E> {
  const Result();
}

final class Success<T, E> extends Result<T, E> {
  const Success(this.value);
  final T value;
}

final class Failure<T, E> extends Result<T, E> {
  const Failure(this.error);
  final E error;
}

/// Expected failures shared by application operations.
enum FailureKind {
  invalidInput,
  unavailable,
  unauthorized,
  conflict,
  unsupported,
  historyEmpty,
}

final class AppFailure {
  const AppFailure(this.kind);
  final FailureKind kind;
}
