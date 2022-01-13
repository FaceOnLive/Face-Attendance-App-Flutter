abstract class Failure {
  String? message;
  Failure({
    this.message,
  });
}

/// When a server failure has happened, Error message can be provided;
class ServerFailure extends Failure {
  final String? errorMessage;
  ServerFailure({this.errorMessage}) : super(message: errorMessage);
}

/// When a Nothing found failure has happened, Error message can be provided;
class NotFoundFailure extends Failure {
  final String? errorMessage;
  NotFoundFailure({this.errorMessage}) : super(message: errorMessage);
}
