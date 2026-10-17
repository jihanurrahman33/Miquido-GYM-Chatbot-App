abstract class Failure {
  final String message;
  final int? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => message;
}

class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Local storage operation failed', int? code])
      : super(code: code);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation error occurred', int? code])
      : super(code: code);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found', int? code])
      : super(code: code);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred', int? code])
      : super(code: code);
}
