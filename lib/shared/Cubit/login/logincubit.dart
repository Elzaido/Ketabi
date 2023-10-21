// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:book_swapping/modules/authentication/loginverify.dart';
import 'package:book_swapping/modules/authentication/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../models/user_model.dart';
import '../../../modules/authentication/login.dart';
import 'loginstate.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);
  bool isPass = true;

  void verifyFun({
    required String phone,
    required BuildContext context,
  }) async {
    emit(VerifyLoadingState());

    try {
      // Verify the phone number using Firebase Authentication
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-retrieval of SMS code succeeded, but we don't need to handle it here.
        },
        verificationFailed: (FirebaseAuthException e) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Register()),
          );
          emit(VerifyFaildState());
          log("Verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) async {
          final isRegistered = await isUserRegistered(phone);

          if (isRegistered) {
            LoginPage.verify = verificationId;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginVerify()),
            );
            emit(VerifySuccessState());
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Register()),
            );
            emit(VerifyFaildState());
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval of SMS code timed out
          // You can add handling logic here if needed
        },
      );
    } catch (error) {
      emit(VerifyFaildState());
      log("Error during phone verification: $error");
    }
  }

  Future<bool> isUserRegistered(String phone) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (error) {
      log("Error querying Firestore: $error");
      return false;
    }
  }

  FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  Future<String> loginCubit({
    required String code,
    required context,
  }) async {
    emit(LoginLoadingState());

    // Request permission and get the new FCM token
    await fMessaging.requestPermission();
    String? newToken = await fMessaging.getToken();

    if (newToken != null) {
      log('Push Token: $newToken');

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: LoginPage.verify,
        smsCode: code,
      );

      try {
        UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
        User? user = authResult.user;

        if (user != null) {
          // Update the user's token in Firestore
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'push_token': newToken,
          });

          emit(LoginSuccessState(user.uid));
          return user.uid;
        } else {
          emit(LoginFaildState());
          return "Error: User not found";
        }
      } catch (error) {
        emit(LoginFaildState());
        return "Error: $error";
      }
    } else {
      emit(LoginFaildState());
      return "Error: Token not found";
    }
  }


  Future<UserCredential> signInWithGoogle() async {
    try {
      emit(GoogleLoadingState());
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        throw const TlsException("Google Sign-In was canceled.");
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase Authentication
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Request permission and get the new FCM token
      await fMessaging.requestPermission();
      String? newToken = await fMessaging.getToken();

      if (newToken != null)
       {log('Push Token: $newToken');}

      // Create user and emit success state
      createUser(
          name: userCredential.user!.displayName,
          email: userCredential.user!.email,
          phone: userCredential.user!.phoneNumber ?? '',
          uId: userCredential.user!.uid,
          token: newToken);

      emit(GoogleSuccessState(userCredential.user!.uid));
      return userCredential;
    } catch (e) {
      // Handle errors here
      emit(GoogleFaildState());
      log("Google Sign-In Error: $e");
      throw TlsException("Google Sign-In failed: $e");
    }
  }


  Future<void> createUser({
    required String? name,
    required String? email,
    required String? phone,
    required String? uId,
    required String? token,
  }) async {
    UserModel model = UserModel(
      name: name,
      email: email,
      phone: phone,
      image:
      'https://th.bing.com/th/id/OIP.IhLi5SNoTJG7at5pDZ4_wAHaHa?pid=ImgDet&rs=1',
      uId: uId!,
      pushToken: token!,
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .set(model.toMap());
      // Return a success signal or value here if needed.
    } catch (error) {
      // Handle the error here or return an error signal.
      print(error);
    }
  }
}
