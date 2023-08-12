// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:book_swapping/Layout/home_layout.dart';
import 'package:book_swapping/shared/Cubit/login/logincubit.dart';
import 'package:book_swapping/shared/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import '../../network/local/cache_helper.dart';
import '../../shared/Cubit/login/loginstate.dart';
import '../../shared/component.dart';
import 'login.dart';

class LoginVerify extends StatelessWidget {
  LoginVerify({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var code = "";

    return BlocProvider(
        create: (BuildContext context) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginState>(listener: (context, state) {
          if (state is LoginSuccessState) {
            CacheHelper.saveDate(key: 'uId', value: state.uId).then((value) {
              defaultToast(
                  massage: 'تم التحقق من رقم الهاتف بنجاح',
                  state: ToastStates.SUCCESS);
              navigateAndFinish(context: context, widget: HomeLayout());
            });
          } else if (state is LoginFaildState) {
            defaultToast(
                massage: 'هناك مشكلة في عملية تسجيل الدخول, تحقق الرمز المدخل',
                state: ToastStates.ERROR);
          }
        }, builder: (context, state) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                ),
              ),
              elevation: 0,
            ),
            body: Container(
              margin: EdgeInsets.only(left: 25, right: 25),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/auth.png',
                      width: 180,
                      height: 180,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "التحقق من الهاتف",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo'),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Pinput(
                      length: 6,
                      onChanged: (value) {
                        code = value;
                      },
                      showCursor: true,
                      onCompleted: (pin) => print(pin),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            LoginCubit.get(context)
                                .loginCubit(code: code, context: context);
                          },
                          child: state is LoginLoadingState
                              ? Center(
                                  child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  color: mainColor,
                                  strokeWidth: 3,
                                ))
                              : Text(
                                  "تحقق من رقم الهاتف",
                                  style: TextStyle(fontFamily: 'Cairo'),
                                ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                            child: Text(
                              "تغيير رقم الهاتف؟",
                              style: TextStyle(
                                  color: Colors.black, fontFamily: 'Cairo'),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
