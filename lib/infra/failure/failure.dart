abstract class Failure {}

class AppFailure extends Failure {
  String? msg;
  AppFailure({this.msg});

  @override
  String toString() => msg ?? '';
}

class AuthFailure extends Failure {
  String? msg;
  AuthFailure({this.msg});

  @override
  String toString() => msg ?? '';
}
