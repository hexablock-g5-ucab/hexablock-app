/// Application port for operation metadata. Adapters choose the destination.
abstract interface class ILogger {
  void info(String message);
  void error(String message, Object error, StackTrace stackTrace);
}
