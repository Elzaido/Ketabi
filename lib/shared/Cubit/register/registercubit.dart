// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:developer';
import 'package:book_swapping/modules/authentication/login.dart';
import 'package:book_swapping/modules/authentication/register.dart';
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
        });
      }
    });
  }

  void verifyFun2({
    required String name,
    required String email,
    required String phone,
    required context,
  }) {
    emit(LoadingVerifiyRegisterState());
    FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        emit(FaildVerifiyRegisterState());
      },
      codeSent: (String verificationId, int? resendToken) {
        CollectionReference usersRef =
            FirebaseFirestore.instance.collection('users');
        Future<bool> isRegistered =
            usersRef.where('phone', isEqualTo: phone).get().then((snapshot) {
          return snapshot.docs.isNotEmpty;
        });
        // If the user is registered, navigate to the home page
        isRegistered.then((registered) {
          if (!registered) {
            Register.verify = verificationId;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RegisterVerify(
                          name: name,
                          email: email,
                          phone: phone,
                        )));
            emit(SuccessVerifiyRegisterState());
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
            emit(FaildVerifiyRegisterState());
          }
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    )
        .catchError((error) {
      emit(FaildVerifiyRegisterState());
    });
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
