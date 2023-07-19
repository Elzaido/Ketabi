// ignore_for_file: prefer_typing_uninitialized_variables

abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

class LoadingRegisterState extends RegisterState {}

class ChangeScureState extends RegisterState {}

class RegisterSuccessState extends RegisterState {}

class RegisterFaildState extends RegisterState {
  final error;

  RegisterFaildState(this.error);
}

class CreateSuccessState extends RegisterState {}

class CreateFaildState extends RegisterState {
  final error;

  CreateFaildState(this.error);
}
