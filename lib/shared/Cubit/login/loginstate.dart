// ignore_for_file: prefer_typing_uninitialized_variables

abstract class loginState {}

class loginInitialState extends loginState {}

class verifyLoadingState extends loginState {}

class verifySuccessState extends loginState {}

class verifyFaildState extends loginState {}

// login States

class loginLoadingState extends loginState {}

class loginSuccessState extends loginState {
  final uId;

  loginSuccessState(this.uId);
}

class loginFaildState extends loginState {}

// Google SignUp States

class googleLoadingState extends loginState {}

class googleSuccessState extends loginState {
  final uId;

  googleSuccessState(this.uId);
}

class googleFaildState extends loginState {}
