// ignore_for_file: prefer_typing_uninitialized_variables

abstract class verifyState {}

class verifyInitialState extends verifyState {}

class ChangeScureState extends verifyState {}

class verifyLoadingState extends verifyState {}

class verifySuccessState extends verifyState {
  final uId;

  verifySuccessState(this.uId);
}

class verifyFaildState extends verifyState {}

// Google SignUp States

class googleLoadingState extends verifyState {}

class googleSuccessState extends verifyState {
  final uId;

  googleSuccessState(this.uId);
}

class googleFaildState extends verifyState {}
