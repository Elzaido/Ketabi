// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/Cubit/register/registercubit.dart';
import '../../shared/Cubit/register/registerstate.dart';
import '../../shared/component.dart';
import '../../shared/constant.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  static String verify = "";

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var phone = "";

  var formKey = GlobalKey<FormState>();

  final nameControl = TextEditingController();

  final phoneControl = TextEditingController();

  final countryControl = TextEditingController();

  final emailControl = TextEditingController();

  bool isPass1 = true;

  @override
  void initState() {
    countryControl.text = "+962";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
        if (state is RegisterFaildState) {
          defaultToast(massage: state.error, state: ToastStates.ERROR);
        }
      }, builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
          body: Stack(
            children: [
              Center(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Text(
                          'هيا نبدأ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.black,
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        formField(
                            control: nameControl,
                            isScure: false,
                            label: 'الإسم',
                            prefIcon: Icon(Icons.person_outline),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'يجب إدخال الإسم';
                              } else {
                                return null;
                              }
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        formField(
                            control: emailControl,
                            isScure: false,
                            label: 'الريد الإلكتروني',
                            prefIcon: Icon(Icons.email),
                            inputType: TextInputType.emailAddress,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'يجب إدخال البريد الإلكتروني';
                              } else {
                                return null;
                              }
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: countryControl,
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
                                  onChanged: (value) {
                                    phone = value;
                                  },
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
                              if (formKey.currentState!.validate()) {
                                RegisterCubit.get(context).verifyFun2(
                                    name: nameControl.text,
                                    email: emailControl.text,
                                    phone:
                                        countryControl.text + phoneControl.text,
                                    context: context);
                              }
                            },
                            child: Text(
                              "إنشاء حساب",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                              ),
                            ),
                            color: mainColor),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                )),
                            Text(
                              'لديك حساب؟',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                              ),
                            ),
                            SizedBox(
                              width: 1,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              if (state is LoadingVerifyRegisterState) loading(),
            ],
          ),
        );
      }),
    );
  }
}
