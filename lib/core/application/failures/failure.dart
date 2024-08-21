enum FailureType {
  log,
  message;

  bool get isLog => this == FailureType.log;
  bool get isMessage => this == FailureType.message;
}

final class Failure implements Exception {
  const Failure._({
    required this.type,
    required this.message,
    this.stack,
  });

  final FailureType type;
  final String message;
  final StackTrace? stack;

  factory Failure.log(String message, StackTrace stack) {
    return Failure._(
      type: FailureType.log,
      message: message,
      stack: stack,
    );
  }

  factory Failure.message(String message) {
    return Failure._(
      type: FailureType.message,
      message: message,
    );
  }
}
