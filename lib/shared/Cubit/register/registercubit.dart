// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:book_swapping/modules/authentication/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/user_model.dart';
import '../../../modules/authentication/registerverify.dart';
import 'registerstate.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool isPass2 = true;

  void scureChange2() {
    isPass2 = !isPass2;
    emit(ChangeScureState());
  }

  void userRegister({
    required String? name,
    required String? email,
    required String? phone,
    required String code,
  }) {
    emit(LoadingRegisterState());

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: Register.verify, smsCode: code);

    // Sign the user in (or link) with the credential
    FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      creatUser(
        name: name,
        email: email,
        phone: phone,
        uId: value.user!.uid,
      );
      //we remove it cuz it will performed before the create user and this will make a latency.
      //emit(RegisterSuccessState());
    }).catchError((error) {
      emit(RegisterFaildState(error));
    });
  }

  void verifyFun2({
    required String name,
    required String email,
    required String phone,
    required context,
  }) {
    emit(LoadingRegisterState());
    FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        CollectionReference usersRef =
            FirebaseFirestore.instance.collection('users');
        Future<bool> isRegistered =
            usersRef.where('phone', isEqualTo: phone).get().then((snapshot) {
          return snapshot.docs.isNotEmpty;
        });
        // If the user is registered, navigate to the home page
        isRegistered.then((registered) {
          if (registered) {
            print('this account is already exist');
          } else {
            Register.verify = verificationId;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RegisterVerify(
                          name: name,
                          email: email,
                          phone: phone,
                        )));
            emit(RegisterSuccessState());
          }
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    )
        .catchError((error) {
      emit(RegisterFaildState(error));
    });
  }

  void creatUser({
    required String? name,
    required String? email,
    required String? phone,
    required String uId,
  }) {
    UserModel model = UserModel(
      name: name,
      email: email,
      phone: phone,
      image:
          'https://th.bing.com/th/id/OIP.IhLi5SNoTJG7at5pDZ4_wAHaHa?pid=ImgDet&rs=1',
      uId: uId,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(CreateSuccessState());
    }).catchError((error) {
      emit(CreateFaildState(error));
      print(error.toString() + 'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
    });
  }
}
