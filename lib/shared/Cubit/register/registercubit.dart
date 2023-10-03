// ignore_for_file: non_constant_identifier_names, unused_local_variable, use_build_context_synchronously

import 'dart:developer';
import 'package:book_swapping/modules/authentication/login.dart';
import 'package:book_swapping/modules/authentication/register.dart';
import 'package:book_swapping/shared/component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/user_model.dart';
import '../../../modules/authentication/registerverify.dart';
import '../../constant.dart';
import 'registerstate.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool isPass2 = true;

  void scureChange2() {
    isPass2 = !isPass2;
    emit(ChangeScureState());
  }

  FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  Future<void> userRegister({
    required String? name,
    required String? email,
    required String? phone,
    required String code,
  }) async {
    emit(LoadingRegisterState());
    await fMessaging.requestPermission();
    await fMessaging.getToken().then((t) {
      if (t != null) {
        log('Push Token: $t');
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: Register.verify, smsCode: code);

        // Sign the user in (or link) with the credential
        FirebaseAuth.instance.signInWithCredential(credential).then((value) {
          uId = value.user!.uid;
          creatUser(
            name: name,
            email: email,
            phone: phone,
            uId: value.user!.uid,
            token: t,
          );
          emit(RegisterSuccessState());
        }).catchError((error) {
          emit(RegisterFaildState(error));
          log(error);
        });
      }
    });
  }

  void verifyFun2({
    required String name,
    required String email,
    required String phone,
    required BuildContext context,
  }) async {
    try {
      // Show loading state
      emit(LoadingVerifyRegisterState());

      // Verify the phone number using Firebase Authentication
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-retrieval of SMS code succeeded, but we don't need to handle it here.
        },
        verificationFailed: (FirebaseAuthException e) {
          // Verification failed
          emit(FaildVerifyRegisterState());
          log("Verification failed: ${e.message}");
          defaultToast(
              massage: 'الرجاء إستخدام الأرقام التجريبية فقط',
              state: ToastStates.ERROR);
        },
        codeSent: (String verificationId, int? resendToken) async {
          // Check if the user is already registered
          final isRegistered = await isUserRegistered(phone);

          if (!isRegistered) {
            // Store the verification ID and navigate to verification screen
            Register.verify = verificationId;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterVerify(
                  name: name,
                  email: email,
                  phone: phone,
                ),
              ),
            );
            emit(SuccessVerifyRegisterState());
          } else {
            // User is already registered, navigate to login screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
            emit(FaildVerifyRegisterState());
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval of SMS code timed out
          // You can add handling logic here if needed
        },
      );
    } catch (error) {
      // Handle other errors
      emit(FaildVerifyRegisterState());
      log("Error during phone verification: $error");
    }
  }

  Future<bool> isUserRegistered(String phone) async {
    try {
      // Check if a user with the given phone number exists in Firestore
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (error) {
      // Handle Firestore query error here
      log("Error querying Firestore: $error");
      return false; // Assume user is not registered in case of error
    }
  }

  void creatUser({
    required String? name,
    required String? email,
    required String? phone,
    required String? uId,
    required String token,
  }) {
    UserModel model = UserModel(
        name: name,
        email: email,
        phone: phone,
        image:
            'https://th.bing.com/th/id/OIP.IhLi5SNoTJG7at5pDZ4_wAHaHa?pid=ImgDet&rs=1',
        uId: uId!,
        pushToken: token);

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(CreateSuccessState(uId));
    }).catchError((error) {
      emit(CreateFaildState(error));
    });
  }
}
