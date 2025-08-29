
abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class ChangePasswordState extends LoginStates {}

class LoginLoadingState extends LoginStates {}
class GetAlladminsSuccessState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  

  LoginSuccessState();
}

class LoginErrorState extends LoginStates {
  final String error;

  LoginErrorState(this.error);
}
