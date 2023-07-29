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

class LoginCubit extends Cubit<loginState> {
  LoginCubit() : super(loginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);
  // الأوبجكت بساعدني أوصل للداتا
  bool isPass = true;

  void verifyFun({
    required String phone,
    required context,
  }) {
    emit(verifyLoadingState());
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Register()));
        emit(verifyFaildState());
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
            emit(verifySuccessState());
          }
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void loginCubit({
    required String code,
    required context,
  }) {
    emit(loginLoadingState());

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: LoginPage.verify, smsCode: code);

    // Sign the user in (or link) with the credential
    FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      uId = value.user!.uid;
      emit(loginSuccessState(
        value.user!.uid,
      ));
    }).catchError((error) {
      emit(loginFaildState());
    });
  }

  // goolgeSignIn() async {
  //   emit(googleLoadingState());

  //   final googleSignIn = GoogleSignIn();
  //   GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  //   GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  //   AuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );

  //   await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
  //     print(value.user?.displayName);
  //     creatUser(
  //         name: value.user?.displayName,
  //         email: value.user?.email,
  //         phone: value.user?.phoneNumber,
  //         uId: value.user?.uid);
  //     emit(googleSuccessState(uId));
  //   }).catchError((error) {
  //     emit(googleFaildState());
  //     print(error);
  //   });
  // }

  Future<UserCredential> signInWithGoogle() async {
    try {
      emit(googleLoadingState());
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
        emit(googleSuccessState(uId));
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
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(googleSuccessState(uId));
    }).catchError((error) {
      emit(googleFaildState());
      print(error.toString());
    });
  }
}
