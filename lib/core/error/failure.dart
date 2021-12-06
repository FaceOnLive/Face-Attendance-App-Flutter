abstract class Failure {
  String? message;
  Failure({
    this.message,
  });
}

class ServerFailure extends Failure {
  final String? errorMessage;
  ServerFailure({this.errorMessage}) : super(message: errorMessage);
}

class NotFoundFailure extends Failure {
  final String? errorMessage;
  NotFoundFailure({this.errorMessage}) : super(message: errorMessage);
}
