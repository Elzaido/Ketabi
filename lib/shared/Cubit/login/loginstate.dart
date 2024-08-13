// ignore_for_file: prefer_typing_uninitialized_variables

abstract class LoginState {}

class LoginInitialState extends LoginState {}

class VerifyLoadingState extends LoginState {}

class VerifySuccessState extends LoginState {}

class VerifyFaildState extends LoginState {}

// login States

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final uId;

  LoginSuccessState(this.uId);
}

class LoginFaildState extends LoginState {}

// Google SignUp States

class GoogleLoadingState extends LoginState {}

class GoogleSuccessState extends LoginState {
  final uId;

  GoogleSuccessState(this.uId);
}

class GoogleFaildState extends LoginState {}
