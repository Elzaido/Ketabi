// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:book_swapping/shared/Cubit/login/logincubit.dart';
import 'package:book_swapping/shared/Cubit/login/loginstate.dart';
import 'package:book_swapping/shared/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';
import '../../shared/component.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneControl = TextEditingController();

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
        child: BlocConsumer<LoginCubit, LoginState>(listener: (context, state) {
          if (state is VerifyFaildState) {
            defaultToast(
                massage: 'الرقم غير مسجل, قم بإنشاء حساب أولاً',
                state: ToastStates.ERROR);
          }
        }, builder: (context, state) {
          return Scaffold(
              body: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/login.png',
                        width: 180,
                        height: 180,
                      ),
                      SizedBox(
                        height: 20,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: countryController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              flex: 4,
                              child: TextFormField(
                                controller: phoneControl,
                                // onChanged: (value) {
                                //   phone = value;
                                // },
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintTextDirection: TextDirection.rtl,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: "  رقم الهاتف",
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'يجب إدخال رقم الهاتف';
                                  } else {
                                    return null;
                                  }
                                },
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      button(
                          onPressed: () {
                            LoginCubit.get(context).verifyFun(
                                phone:
                                    countryController.text + phoneControl.text,
                                context: context);
                          },
                          child: Text(
                            "أرسل الرمز",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                            ),
                          ),
                          color: mainColor),
                      SizedBox(
                        height: 10,
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
                      SizedBox(
                        height: 20,
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
                            // Trigger the authentication flow
                            final GoogleSignInAccount? googleUser =
                                await GoogleSignIn().signIn();

                            // Obtain the auth details from the request
                            final GoogleSignInAuthentication? googleAuth =
                                await googleUser?.authentication;

                            // Create a new credential
                            final credential = GoogleAuthProvider.credential(
                              accessToken: googleAuth?.accessToken,
                              idToken: googleAuth?.idToken,
                            );

                            // Once signed in, return the UserCredential
                            return await FirebaseAuth.instance
                                .signInWithCredential(credential)
                                .then((value) {
                              LoginCubit.get(context).creatUser(
                                  name: value.user!.displayName,
                                  email: value.user!.email,
                                  phone: value.user!.phoneNumber,
                                  uId: value.user!.uid);
                            });
                          })
                    ],
                  ),
                ),
              ),
              if (state is VerifyLoadingState) loading(),
            ],
          ));
        }));
  }
}
