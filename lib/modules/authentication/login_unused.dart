// // ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../Layout/home_layout.dart';
// import '../../network/local/cache_helper.dart';
// import '../../shared/Cubit/login/cubit.dart';
// import '../../shared/Cubit/login/state.dart';
// import '../../shared/component.dart';
// import 'register.dart';

// class LoginScreen extends StatelessWidget {
//   var formKey = GlobalKey<FormState>();
//   final emailControl = TextEditingController();
//   final passControl = TextEditingController();
//   //bool isPass = true;

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (BuildContext context) => LoginCubit(),
//       child: BlocConsumer<LoginCubit, LoginState>(
//         listener: (context, state) {
//           if (state is LoginFaildState) {
//             defaultToast(
//                 massage: 'خطأ في البريد الإلكتروني أو كلمة السر',
//                 state: ToastStates.ERROR);
//           }
//           if (state is LoginSuccessState) {
//             CacheHelper.saveDate(key: 'uId', value: state.uId).then((value) {
//               navigateAndFinish(context: context, widget: HomeLayout());
//             });
//           }
//         },
//         builder: (context, state) {
//           return Scaffold(
//               body: Column(
//             children: [
//               const SizedBox(
//                 height: 30,
//               ),
//               Expanded(
//                 child: Center(
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Form(
//                         key: formKey,
//                         child: Column(
//                           children: [
//                             Center(
//                               child: Image.asset(
//                                 "assets/login.png",
//                                 height: 170,
//                                 width: 250,
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             const Text(
//                               'أهلاً بك من جديد',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontFamily: 'Cairo',
//                                 color: Colors.black,
//                                 fontSize: 25,
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             const SizedBox(
//                               height: 30,
//                             ),
//                             formField(
//                                 control: emailControl,
//                                 isScure: false,
//                                 label: 'بريدك الإلكتروني',
//                                 prefIcon: const Icon(Icons.email),
//                                 validator: (String? value) {
//                                   if (value!.isEmpty) {
//                                     return 'يجب إدخال البريد الإلكتروني';
//                                   }
//                                   return null;
//                                 }),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             formField(
//                                 control: passControl,
//                                 isScure: LoginCubit.get(context).isPass,
//                                 label: 'كلمة السر',
//                                 onSubmit: (value) {
//                                   // if (formKey.currentState!.validate()) {
//                                   //   LoginCubit.get(context).loginCubit(
//                                   //       email: emailControl.text,
//                                   //       password: passControl.text);
//                                   // }
//                                 },
//                                 prefIcon: const Icon(
//                                   Icons.lock,
//                                 ),
//                                 validator: (String? value) {
//                                   if (value!.isEmpty) {
//                                     return 'يجب إدخال كلمة السر';
//                                   }
//                                   return null;
//                                 },
//                                 suffButton: IconButton(
//                                   icon: LoginCubit.get(context).isPass
//                                       ? const Icon(
//                                           Icons.visibility_off,
//                                         )
//                                       : const Icon(Icons.remove_red_eye,
//                                           color: Colors.grey),
//                                   onPressed: () {
//                                     LoginCubit.get(context).scureChange();
//                                   },
//                                 )),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Padding(
//                                 padding: const EdgeInsets.only(
//                                   right: 10,
//                                 ),
//                                 child: Container(
//                                     width: double.infinity,
//                                     child: TextButton(
//                                       onPressed: () {},
//                                       child: Text(
//                                         'نسيت كلمة السر؟',
//                                         textAlign: TextAlign.right,
//                                         style: TextStyle(
//                                           fontFamily: 'Cairo',
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.green,
//                                         ),
//                                       ),
//                                     ))),
//                             SizedBox(
//                               height: 20,
//                             ),
//                             // Container(
//                             //     decoration: BoxDecoration(
//                             //         color: Colors.green,
//                             //         borderRadius: BorderRadius.circular(30)),
//                             //     width: 200,
//                             //     height: 50,
//                             //     child:
//                             //      state is! LoginLoadingState
//                             //         ? MaterialButton(
//                             //             //color: Colors.green,
//                             //             child: const Text(
//                             //               'تسجيل الدخول',
//                             //               style: TextStyle(
//                             //                   fontFamily: 'Cairo',
//                             //                   color: Colors.white,
//                             //                   fontSize: 20,
//                             //                   fontWeight: FontWeight.bold),
//                             //             ),
//                             //             onPressed: () {
//                             //               // if (formKey.currentState!
//                             //               //     .validate()) {
//                             //               //   LoginCubit.get(context).loginCubit(
//                             //               //       email: emailControl.text,
//                             //               //       password: passControl.text);
//                             //               // }
//                             //             })
//                             //         : const Center(
//                             //             child: CircularProgressIndicator(
//                             //             color: Colors.grey,
//                             //             backgroundColor: Colors.white,
//                             //             strokeWidth: 3,
//                             //           ))),
//                             const SizedBox(
//                               height: 30,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Expanded(
//                                   child: MaterialButton(
//                                     onPressed: () {},
//                                     child: Container(
//                                       height: 50,
//                                       width: 150,
//                                       decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                           color: Colors.indigo[700]),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: const [
//                                           Text(
//                                             'f',
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white,
//                                               fontSize: 25,
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 10,
//                                           ),
//                                           Text('Facebook',
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                               )),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 15,
//                                 ),
//                                 Expanded(
//                                   child: MaterialButton(
//                                     onPressed: () {},
//                                     child: Container(
//                                       height: 50,
//                                       width: 150,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: Colors.red,
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: const [
//                                           Text(
//                                             'G',
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white,
//                                               fontSize: 25,
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 10,
//                                           ),
//                                           Text('Google',
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                               )),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 30,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 TextButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                           // from where :
//                                           context,
//                                           // where to send :
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   Register()));
//                                     },
//                                     child: const Text(
//                                       'إنشاء حساب',
//                                       style: TextStyle(
//                                         fontFamily: 'Cairo',
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.green,
//                                       ),
//                                     )),
//                                 Text(
//                                   'ليس لديك حساب؟',
//                                   style: TextStyle(fontFamily: 'Cairo'),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ));
//         },
//       ),
//     );
//   }
// }
