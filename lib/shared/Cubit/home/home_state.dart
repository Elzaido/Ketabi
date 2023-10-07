abstract class HomeStates {}

class InitHomeState extends HomeStates {}

class ChangeNavState extends HomeStates {}

class AddPostState extends HomeStates {}

// User data States =>

class LoadingGetUserDataState extends HomeStates {}

class SuccessGetUserDataState extends HomeStates {}

class ErrorGetUserDataState extends HomeStates {
  final String error;

  ErrorGetUserDataState(this.error);
}

class SuccessPickProfileImageState extends HomeStates {}

class ErrorPickProfileImageState extends HomeStates {}

class SuccessUploadProfileImageState extends HomeStates {}

class ErrorUploadProfileImageState extends HomeStates {}

class LoadingUpdateUserState extends HomeStates {}

class SuccessUpdateUserState extends HomeStates {}

class ErrorUpdateUserState extends HomeStates {}

// Posts States =>

class SuccessPickPostImageState extends HomeStates {}

class ErrorPickPostImageState extends HomeStates {}

class RemovePostImageState extends HomeStates {}

class LoadingUploadPostState extends HomeStates {}

class SuccessUploadPostState extends HomeStates {}

class ErrorUploadPostState extends HomeStates {}

class LoadingGetPostDataState extends HomeStates {}

class SuccessDeletePostState extends HomeStates {}

class ErrorDeletePostState extends HomeStates {}

class SuccessGetPostDataState extends HomeStates {}

class ErrorGetPostDataState extends HomeStates {
  final String error;

  ErrorGetPostDataState(this.error);
}

class ChangeSelectionState extends HomeStates {}

// All User Data States

class LoadingAllUserDataState extends HomeStates {}

class SuccessAllUserDataState extends HomeStates {}

class FailedAllUserDataState extends HomeStates {
  final String error;

  FailedAllUserDataState(this.error);
}

// Chat States

class SuccessSendMessage extends HomeStates {}

class ErrorSendMessage extends HomeStates {}

class SuccessGetMessage extends HomeStates {}

class ErrorGetMessage extends HomeStates {}

class SuccessPickChatImageState extends HomeStates {}

class ErrorPickChatImageState extends HomeStates {}

class LoadingUploadChatMessageState extends HomeStates {}

class SuccessUploadChatImageState extends HomeStates {}

class ErrorUploadChatImageState extends HomeStates {}

// Notification states:

class SuccessSendMessagenotification extends HomeStates {}

class ErrorSendMessagenotification extends HomeStates {}

// Scan Barcode States:

class LoadingScanState extends HomeStates {}

class SuccessScanState extends HomeStates {}

class ErrorScanState extends HomeStates {}
