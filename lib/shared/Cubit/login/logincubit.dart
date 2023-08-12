import 'dart:io';
import 'package:book_swapping/modules/authentication/loginverify.dart';
import 'package:book_swapping/modules/authentication/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../models/user_model.dart';
import '../../../modules/authentication/login.dart';
import '../../constant.dart';
import 'loginstate.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);
  // الأوبجكت بساعدني أوصل للداتا
  bool isPass = true;

  void verifyFun({
    required String phone,
    required context,
  }) {
    emit(VerifyLoadingState());
    FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Register()));
        emit(VerifyFaildState());
      },
      codeSent: (String verificationId, int? resendToken) {
        CollectionReference usersRef =
            FirebaseFirestore.instance.collection('users');
        Future<bool> isRegistered =
            usersRef.where('phone', isEqualTo: phone).get().then((snapshot) {
          return snapshot.docs.isNotEmpty;
        });
        // If the user is registered, navigate to the verify page
        isRegistered.then((registered) {
          if (registered) {
            LoginPage.verify = verificationId;
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginVerify()));
            emit(VerifySuccessState());
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Register()));
            emit(VerifyFaildState());
          }
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    )
        .catchError((error) {
      emit(VerifyFaildState());
    });
  }

  void loginCubit({
    required String code,
    required context,
  }) {
    emit(LoginLoadingState());

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: LoginPage.verify, smsCode: code);

    // Sign the user in (or link) with the credential
    FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      uId = value.user!.uid;
      emit(LoginSuccessState(
        value.user!.uid,
      ));
    }).catchError((error) {
      emit(LoginFaildState());
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      emit(GoogleLoadingState());
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
        creatUser(
            name: value.user!.displayName,
            email: value.user!.email,
            phone: value.user!.phoneNumber,
            uId: value.user!.uid);
        emit(GoogleSuccessState(uId));
      });
    } on FirebaseAuthException catch (e) {
      final ex = TlsException(e.toString());
      throw ex.message;
    } catch (_) {}
    const ex = TlsException();
    throw ex.message;
  }

  void creatUser({
    required String? name,
    required String? email,
    required String? phone,
    required String? uId,
  }) {
    UserModel model = UserModel(
      name: name,
      email: email,
      phone: phone,
      image:
          'https://th.bing.com/th/id/OIP.IhLi5SNoTJG7at5pDZ4_wAHaHa?pid=ImgDet&rs=1',
      uId: uId!,
      pushToken: '',
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(GoogleSuccessState(uId));
    }).catchError((error) {
      emit(GoogleFaildState());
    });
  }
}
