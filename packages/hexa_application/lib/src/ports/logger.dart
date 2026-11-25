/// Application port for operation metadata. Adapters choose the destination.
abstract interface class ILogger {
  void info(String message);

  /// Receives only the exception type and its original stack trace.
  void error(String message, Type errorType, StackTrace stackTrace);
}
