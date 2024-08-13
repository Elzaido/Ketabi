import 'package:book_swapping/shared/Cubit/home/home_cubit.dart';
import 'package:book_swapping/shared/Cubit/login/logincubit.dart';
import 'package:book_swapping/shared/Cubit/login/loginstate.dart';
import 'package:book_swapping/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Layout/home_layout.dart';
import '../../network/local/cache_helper.dart';
import '../../shared/component.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
          if (state is GoogleSuccessState) {
            CacheHelper.saveDate(key: 'uId', value: state.uId).then((value) {
              defaultToast(
                  massage: 'تم تسجيل الدخول بنجاح', state: ToastStates.SUCCESS);
              navigateAndFinish(context: context, widget: HomeLayout());
            });
          } else if (state is LoginFaildState) {
            defaultToast(
                massage: 'هناك مشكلة في عملية تسجيل الدخول, تحقق الرمز المدخل',
                state: ToastStates.ERROR);
          }
        }, builder: (context, state) {
          return Scaffold(
              body: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/login.png',
                        width: 180,
                        height: 180,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "الرجاء إدخال رقم هاتفك لإتمام عملية تسجبل الدخول",
                        style: TextStyle(fontFamily: 'Cairo'),
                      ),
                      const SizedBox(
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
                          const SizedBox(
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
                      const SizedBox(
                        height: 20,
                      ),
                      button(
                          onPressed: () {
                            LoginCubit.get(context).verifyFun(
                                phone:
                                    countryController.text + phoneControl.text,
                                context: context);
                          },
                          child: const Text(
                            "أرسل الرمز",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                            ),
                          ),
                          color: mainColor),
                      const SizedBox(
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
                                        builder: (context) =>
                                            const Register()));
                              },
                              child: const Text(
                                'إنشاء حساب',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              )),
                          const Text(
                            'ليس لديك حساب؟',
                            style: TextStyle(fontFamily: 'Cairo'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: separator()),
                          const Text('OR'),
                          Expanded(child: separator())
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          onTap: () {
                            LoginCubit.get(context)
                                .signInWithGoogle()
                                .then((value) {
                              HomeCubit.get(context).getUserData();
                            });
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Sign in with Google'),
                              SizedBox(width: 5),
                              Text(
                                'G',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (state is VerifyLoadingState || state is GoogleLoadingState)
                loading(),
            ],
          ));
        }));
  }
}
