// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:book_swapping/shared/Cubit/login/logincubit.dart';
import 'package:book_swapping/shared/Cubit/login/loginstate.dart';
import 'package:book_swapping/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import '../../network/local/cache_helper.dart';
import '../../shared/component.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController countryController = TextEditingController();

  var phone = "";

  @override
  void initState() {
    super.initState();
    // You can initialize your state variables here
    countryController.text =
        '+962'; // For example, setting the initial value of _counter to 42
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => LoginCubit(),
        child:
            BlocConsumer<LoginCubit, verifyState>(listener: (context, state) {
          if (state is verifyFaildState) {
            defaultToast(
                massage: 'الرقم غير مسجل, قم بإنشاء حساب أولاً',
                state: ToastStates.ERROR);
          }
          if (state is verifySuccessState) {
            CacheHelper.saveDate(key: 'uId', value: state.uId);
          }
        }, builder: (context, state) {
          return Scaffold(
              body: Container(
            margin: EdgeInsets.only(left: 25, right: 25),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/login.png',
                    width: 180,
                    height: 180,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "تسجيل الدخول",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "الرجاء إدخال رقم هاتفك لإتمام عملية تسجبل الدخول",
                    style: TextStyle(fontFamily: 'Cairo'),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 40,
                          child: TextField(
                            controller: countryController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Text(
                          "|",
                          style: TextStyle(fontSize: 33, color: Colors.grey),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: TextField(
                          onChanged: (value) {
                            phone = value;
                          },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone",
                          ),
                        ))
                      ],
                    ),
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
                          LoginCubit.get(context).verifyFun(
                              phone: countryController.text + phone,
                              context: context);
                        },
                        child: state is! verifyLoadingState
                            ? Text(
                                "أرسل الرمز",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                color: mainColor,
                                strokeWidth: 3,
                              ))),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                // from where :
                                context,
                                // where to send :
                                MaterialPageRoute(
                                    builder: (context) => Register()));
                          },
                          child: const Text(
                            'إنشاء حساب',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          )),
                      Text(
                        'ليس لديك حساب؟',
                        style: TextStyle(fontFamily: 'Cairo'),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    icon: const Icon(
                      Ionicons.logo_google,
                      color: Colors.red,
                    ),
                    label: const Text(
                      "Sign in with google",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () async {
                      LoginCubit.get(context).goolgeSignIn();
                    },
                  ),
                ],
              ),
            ),
          ));
        }));
  }
}
