/// Application operation with a typed request and result.
abstract interface class UseCase<I, O> {
  Future<O> execute(I input);
}
