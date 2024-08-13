// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:book_swapping/Layout/home_layout.dart';
import 'package:book_swapping/shared/Cubit/register/registercubit.dart';
import 'package:book_swapping/shared/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import '../../network/local/cache_helper.dart';
import '../../shared/Cubit/register/registerstate.dart';
import '../../shared/component.dart';
import 'login.dart';

class RegisterVerify extends StatelessWidget {
  RegisterVerify({super.key, this.name, this.email, this.phone});

  final String? name;
  final String? email;
  final String? phone;

  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var code = "";

    return BlocProvider(
        create: (BuildContext context) => RegisterCubit(),
        child: BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
          if (state is CreateSuccessState) {
            CacheHelper.saveDate(key: 'uId', value: state.uId).then((value) {
              defaultToast(
                  massage: 'تم التحقق من رقم الهاتف بنجاح',
                  state: ToastStates.SUCCESS);
              navigateAndFinish(context: context, widget: HomeLayout());
            });
          } else if (state is CreateFaildState) {
            defaultToast(
                massage: 'هناك مشكلة في عملية إنشاء الحساب',
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
            body: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(15),
                    child: Column(
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
                        button(
                            onPressed: () {
                              RegisterCubit.get(context).userRegister(
                                  name: name,
                                  email: email,
                                  phone: phone,
                                  code: code);
                            },
                            child: Text(
                              "تحقق من رقم الهاتف",
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                            color: mainColor),
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
                if (state is LoadingRegisterState) loading(),
              ],
            ),
          );
        }));
  }
}
