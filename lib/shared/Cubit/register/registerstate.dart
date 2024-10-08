// ignore_for_file: prefer_typing_uninitialized_variables

abstract class RegisterState {}

// register states

class RegisterInitialState extends RegisterState {}

class LoadingRegisterState extends RegisterState {}

class ChangeScureState extends RegisterState {}

class RegisterSuccessState extends RegisterState {}

class RegisterFaildState extends RegisterState {
  final error;

  RegisterFaildState(this.error);
}

// create account states

class CreateSuccessState extends RegisterState {
  final uId;

  CreateSuccessState(this.uId);
}

class CreateFaildState extends RegisterState {
  final error;

  CreateFaildState(this.error);
}

class SuccessCreatePhoneRecord extends RegisterState {}

class ErrorCreatePhoneRecord extends RegisterState {}

// regsiter verify states

class LoadingVerifyRegisterState extends RegisterState {}

class SuccessVerifyRegisterState extends RegisterState {}

class FaildVerifyRegisterState extends RegisterState {}
