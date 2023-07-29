// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/chat_model.dart';
import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../../modules/chat/chats.dart';
import '../../../modules/main_pages/add_post.dart';
import '../../../modules/main_pages/my_ads.dart';
import '../../../modules/main_pages/home.dart';
import '../../../modules/profile/profile.dart';
import '../../constant.dart';
import 'home_state.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitHomeState());

  static HomeCubit get(context) => BlocProvider.of(context);
  UserModel? userModel;
  File? profileImage;
  File? postImage;
  File? chatImage;

  var picker = ImagePicker();
  String selectedOption = 'تبديل';
  int currentIndex = 4;

  List<Widget> screens = [
    Profile(),
    MyAds(),
    Add_Post(),
    Chats(),
    Home(),
  ];

  List<String> titles = [
    'حسابي',
    'إعلاناتي',
    'أضف إعلان',
    'دردشاتي',
    'الرئيسية',
  ];

  List<Widget> images = [
    Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/Ad here.png'))),
    ),
  ];

  void changeNav(int index) {
    if (index == 2) {
      emit(AddPostState());
    } else {
      currentIndex = index;
      emit(ChangeNavState());
    }
  }

  void getUserData() {
    emit(LoadingGetUserDataState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.formJson(value.data()!);
      print(userModel!.email);
      emit(SuccessGetUserDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorGetUserDataState(error.toString()));
    });
  }

  Future<void> pickProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SuccessPickProfileImageState());
      print(pickedFile.path.toString());
    } else {
      print('No image selected');
      emit(ErrorPickProfileImageState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
  }) {
    emit(LoadingUpdateUserState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUserData(name: name, phone: phone, image: value);
        emit(SuccessUploadProfileImageState());
        print(value);
      }).catchError((onError) {
        emit(ErrorUploadProfileImageState());
        print(onError.toString() + '---- 1');
      });
    }).catchError((onError) {
      emit(ErrorUploadProfileImageState());
      print(onError.toString() + '---- 2');
    });
  }

  void updateUserData({
    required String name,
    required String phone,
    String? image,
    String? cover,
  }) {
    emit(LoadingUpdateUserState());
    UserModel model = UserModel(
      name: name,
      phone: phone,
      image: image ?? userModel!.image,
      email: userModel!.email,
      uId: userModel!.uId,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(model.toMap())
        .then((value) {
      emit(SuccessUpdateUserState());
      // There is no emit here cuz i call the getUserData() function and there is an emit success on it ...
      getUserData();
    }).catchError((onError) {
      emit(ErrorUpdateUserState());
    });
  }

  Future<void> pickPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SuccessPickPostImageState());
    } else {
      print('No image selected');
      emit(ErrorPickPostImageState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(RemovePostImageState());
  }

  void uplaodPostImage({
    required String text,
    required String date,
    required String type,
  }) {
    emit(LoadingUploadPostState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(date: date, text: text, postImage: value, type: type);
        emit(SuccessUploadPostState());
        print(value);
      }).catchError((onError) {
        emit(ErrorUploadPostState());
      });
    }).catchError((onError) {
      emit(ErrorUploadPostState());
    });
  }

  void createPost({
    required String text,
    required String date,
    String? postImage,
    required String type,
  }) {
    emit(LoadingUploadPostState());
    PostModel model = PostModel(
      name: userModel!.name,
      userImage: userModel!.image,
      uId: userModel!.uId,
      postText: text,
      date: date,
      type: type,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection('posts')
        // .add creates an id for the post and put the values under it.
        .add(model.toMap())
        .then((value) {
      emit(SuccessUploadPostState());
    }).catchError((onError) {
      emit(ErrorUploadPostState());
    });
  }

  List<PostModel> posts = [];

  void getAllPosts() {
    posts = [];
    emit(LoadingGetPostDataState());
    FirebaseFirestore.instance
        .collection('posts')

        // get() will call the all the posts without being bound by a specific uId.
        .get()
        .then((value) {
      value.docs.forEach(((element) {
        posts.add(PostModel.formJson(element.data()));
      }));
      emit(SuccessGetPostDataState());
    }).catchError((error) {
      emit(ErrorGetPostDataState(error.toString()));
    });
  }

  void getPostsByType({
    required String type,
  }) {
    posts = [];
    emit(LoadingGetPostDataState());
    FirebaseFirestore.instance
        .collection('posts')
        .where('type', isEqualTo: type)
        // get() will call the all the posts without being bound by a specific uId.
        .get()
        .then((value) {
      value.docs.forEach(((element) {
        posts.add(PostModel.formJson(element.data()));
      }));
      emit(SuccessGetPostDataState());
    }).catchError((error) {
      emit(ErrorGetPostDataState(error.toString()));
    });
  }

  void getMyPosts({
    required String uId,
  }) {
    posts = [];
    emit(LoadingGetPostDataState());
    FirebaseFirestore.instance
        .collection('posts')
        .where('uId', isEqualTo: uId)
        // get() will call the all the posts without being bound by a specific uId.
        .get()
        .then((value) {
      value.docs.forEach(((element) {
        posts.add(PostModel.formJson(element.data()));
      }));
      emit(SuccessGetPostDataState());
    }).catchError((error) {
      emit(ErrorGetPostDataState(error.toString()));
    });
  }

  List<UserModel> users = [];

  void getUsers() {
    if (users.isEmpty) {
      emit(LoadingAllUserDataState());
      FirebaseFirestore.instance
          .collection('users')
          // get() will call the all the posts without being bound by a specific uId.
          .get()
          .then((value) {
        value.docs.forEach(((element) {
          if (element.data()['uId'] != uId) {
            users.add(UserModel.formJson(element.data()));
          }
          emit(SuccessAllUserDataState());
        }));
      }).catchError((error) {
        emit(FailedAllUserDataState(error.toString()));
      });
    }
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
    String? Image,
  }) {
    ChatModel model = ChatModel(
        senderId: userModel!.uId,
        receiverId: receiverId,
        date: dateTime,
        text: text,
        image: Image ?? '');

// set my chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SuccessSendMessage());
    }).catchError((error) {
      emit(ErrorSendMessage());
    });

// set receiver chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SuccessGetMessage());
    }).catchError((error) {
      emit(ErrorGetMessage());
    });
  }

  List<ChatModel> chats = [];

  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((event) {
      chats = [];

      event.docs.forEach((element) {
        chats.add(ChatModel.formJson(element.data()));
      });
      emit(SuccessGetMessage());
    });
  }

  Future<void> pickChatImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      chatImage = File(pickedFile.path);
      emit(SuccessPickChatImageState());
    } else {
      print('No image selected');
      emit(ErrorPickChatImageState());
    }
  }

  void SendChatImage({
    required String text,
    required String receiverId,
    required String dateTime,
  }) {
    emit(LoadingUploadChatMessageState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('chats/${Uri.file(chatImage!.path).pathSegments.last}')
        .putFile(chatImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        sendMessage(
            receiverId: receiverId,
            dateTime: dateTime,
            text: text,
            Image: value);
        emit(SuccessUploadChatImageState());
        print(value);
      }).catchError((onError) {
        emit(ErrorUploadChatImageState());
      });
    }).catchError((onError) {
      emit(ErrorUploadChatImageState());
    });
  }

  void removeChatImage() {
    chatImage = null;
    emit(RemovePostImageState());
  }

  void selectedPostType(String value) {
    selectedOption = value;
    emit(ChangeSelectionState());
  }
}
