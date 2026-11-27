import 'result.dart';

/// Application operation with a typed request and result.
abstract interface class UseCase<I, O> {
  Future<Result<O, AppFailure>> execute(I input);
}
