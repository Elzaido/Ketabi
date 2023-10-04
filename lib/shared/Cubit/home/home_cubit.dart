import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/chat_model.dart';
import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../../modules/chat/chats.dart';
import '../../../modules/home.dart';
import '../../../modules/posts/add_post.dart';
import '../../../modules/posts/my_ads.dart';
import '../../../modules/profile/profile.dart';
import '../../constant.dart';
import 'home_state.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitHomeState());

  static HomeCubit get(context) => BlocProvider.of(context);
  UserModel? userModel;
  PostModel? postModel;
  File? profileImage;
  File? postImage;
  File? chatImage;

  String selectedBookType = 'تبديل';
  List<String> bookTypes = ['تبديل', 'بيع', 'تبرع'];

  var picker = ImagePicker();
  int currentIndex = 4;

  List<Widget> screens = [
    const Profile(),
    MyAds(),
    Add_Post(),
    const Chats(),
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
    ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset('assets/Ad here.png'),
    ),
  ];

  void changeNav(int index) {
    if (index == 2) {
      emit(AddPostState());
    } else if (index == 1) {
      getMyPosts(uId: uId!);
      currentIndex = index;
    } else {
      currentIndex = index;
      emit(ChangeNavState());
    }
  }

  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        userModel!.pushToken = t;
        log('Push Token: $t');
      }
    }).catchError((error) {
      log('Push Token Error is: $error');
    });
  }

  Future<void> sendPushNotification(
      String pushToken, String name, String msg) async {
    try {
      final body = {
        "to": pushToken,
        "notification": {"title": name, "body": msg}
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAASHpbT0U:APA91bH4pfTc7KvV4rJWHfJm9cU-bcrxLVfJC0nxQZxFNrGmMWvKca_I9qAYC_I3PJUpCTKjVS3XcQjZM1WGYzu6hb5ylhlK7Q4e11fZYs21xubhYZ6oczogr1bKKG2suo5ssXo4_iI6',
          },
          body: jsonEncode(body));
      emit(SuccessSendMessagenotification());
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      emit(ErrorSendMessagenotification());
      log('sendPushNotification error is: $e');
    }
  }

  void getUserData() {
    emit(LoadingGetUserDataState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) async {
      userModel = UserModel.formJson(value.data()!);
      await getFirebaseMessagingToken();
      emit(SuccessGetUserDataState());
    }).catchError((error) {
      log(error.toString());
      emit(ErrorGetUserDataState(error.toString()));
    });
  }

  Future<void> pickProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SuccessPickProfileImageState());
      log(pickedFile.path.toString());
    } else {
      log('No image selected');
      emit(ErrorPickProfileImageState());
    }
  }

  void updateProfileImage({
    required String name,
    required String phone,
    required String email,
  }) {
    emit(LoadingUpdateUserState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUserData(name: name, phone: phone, image: value, email: email);
        emit(SuccessUploadProfileImageState());
      }).catchError((onError) {
        emit(ErrorUploadProfileImageState());
      });
    }).catchError((onError) {
      emit(ErrorUploadProfileImageState());
    });
  }

  void updateUserData({
    required String name,
    required String phone,
    required String email,
    String? image,
  }) {
    emit(LoadingUpdateUserState());
    UserModel model = UserModel(
      name: name,
      phone: phone,
      image: image ?? userModel!.image,
      email: email,
      uId: userModel!.uId,
      pushToken: userModel!.pushToken,
      chatList: userModel!.chatList,
      favList: userModel!.favList,
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

  Future<void> pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SuccessPickPostImageState());
    } else {
      log('No image selected');
      emit(ErrorPickPostImageState());
    }
  }

  Future<void> pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SuccessPickPostImageState());
    } else {
      log('No image selected');
      emit(ErrorPickPostImageState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(RemovePostImageState());
  }

  void uploadPostImage({
    required String date,
    required String type,
    required String bookName,
    String? bookPrice,
    String? swapedBook,
  }) {
    emit(LoadingUploadPostState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
          date: date,
          bookName: bookName,
          swapedBook: swapedBook,
          bookPrice: bookPrice,
          postImage: value,
          type: type,
          // postId: value
        );
        emit(SuccessUploadPostState());
      }).catchError((onError) {
        emit(ErrorUploadPostState());
      });
    }).catchError((onError) {
      emit(ErrorUploadPostState());
    });
  }

  void createPost({
    required String date,
    required String type,
    required String bookName,
    String? postImage,
    String? bookPrice,
    String? swapedBook,
  }) async {
    emit(LoadingUploadPostState());
    PostModel model = PostModel(
      ownerName: userModel!.name,
      bookName: bookName,
      bookPrice: bookPrice ?? '',
      swapedBook: swapedBook ?? '',
      postId: '',
      userImage: userModel!.image,
      uId: userModel!.uId,
      date: date,
      type: type,
      postImage: postImage ?? '',
    );

    try {
      // Add the post to the 'posts' collection
      DocumentReference postRef = await FirebaseFirestore.instance
          .collection('posts')
          .add(model.toMap());
      // Update the model with the actual post ID
      model.postId = postRef.id;
      // Update the post document with the correct post ID
      await postRef.update({'postId': postRef.id});
      getMyPosts(uId: uId!);
      emit(SuccessUploadPostState());
    } catch (e) {
      emit(ErrorUploadPostState());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      // Delete the post document from the 'posts' collection
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
      getMyPosts(uId: uId!);
      emit(SuccessDeletePostState());
    } catch (e) {
      emit(ErrorDeletePostState());
    }
  }

  List<PostModel> posts = [];

  void getAllPosts() {
    posts = [];
    emit(LoadingGetPostDataState());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
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
        .get()
        .then((value) {
      value.docs.forEach(((element) {
        posts.add(PostModel.formJson(element.data()));
      }));
      emit(SuccessGetPostDataState());
    }).catchError((error) {
      emit(ErrorGetPostDataState(error.toString()));
      log('The Error is: $error');
    });
  }

  void getPostsByTypeAndName({
    required String type,
    required String name,
  }) {
    posts = [];
    emit(LoadingGetPostDataState());
    if (type == 'all') {
      FirebaseFirestore.instance
          .collection('posts')
          .where('bookName', isEqualTo: name) // Filter by name
          .get()
          .then((value) {
        value.docs.forEach(((element) {
          posts.add(PostModel.formJson(element.data()));
        }));
        emit(SuccessGetPostDataState());
      }).catchError((error) {
        emit(ErrorGetPostDataState(error.toString()));
        log('The Error is: $error');
      });
    } else {
      FirebaseFirestore.instance
          .collection('posts')
          .where('type', isEqualTo: type) // Filter by type
          .where('bookName', isEqualTo: name) // Filter by name
          .get()
          .then((value) {
        value.docs.forEach(((element) {
          posts.add(PostModel.formJson(element.data()));
        }));
        emit(SuccessGetPostDataState());
      }).catchError((error) {
        emit(ErrorGetPostDataState(error.toString()));
        log('The Error is: $error');
      });
    }
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

  Future<void> sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
    required String token,
    String? image,
  }) async {
    ChatModel model = ChatModel(
        senderId: userModel!.uId,
        receiverId: receiverId,
        date: dateTime,
        text: text,
        image: image ?? '');

// set my chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      sendPushNotification(token, userModel!.name!, text);
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
        .then((value) async {
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

      for (var element in event.docs) {
        chats.add(ChatModel.formJson(element.data()));
      }
      emit(SuccessGetMessage());
    });
  }

  Future<void> pickChatImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      chatImage = File(pickedFile.path);
      emit(SuccessPickChatImageState());
    } else {
      log('No image selected');
      emit(ErrorPickChatImageState());
    }
  }

  void sendChatImage({
    required String text,
    required String receiverId,
    required String dateTime,
    required String fToken,
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
            image: value,
            token: fToken);
        emit(SuccessUploadChatImageState());
        log(value);
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

  void selectPostType(String value) {
    selectedBookType = value;
    emit(ChangeSelectionState());
  }
}
