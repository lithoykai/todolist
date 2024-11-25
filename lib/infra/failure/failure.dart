abstract class Failure {}

class AppFailure extends Failure {
  String? msg;
  AppFailure({this.msg});

  @override
  String toString() => msg ?? '';
}
