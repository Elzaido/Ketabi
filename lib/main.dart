// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:book_swapping/modules/authentication/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Layout/home_layout.dart';
import 'firebase_options.dart';
import 'modules/on_boarding.dart';
import 'network/local/cache_helper.dart';
import 'shared/Cubit/home/home_cubit.dart';
import 'shared/Style/themes.dart';
import 'shared/bloc_observer.dart';
import 'shared/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Widget widget;
  if (onBoarding != null) {
    if (uId != null) {
      widget = HomeLayout();
    } else {
      widget = LoginPage();
    }
  } else {
    widget = OnBoarding();
  }
  runApp(myApp(widget));
}

class myApp extends StatelessWidget {
  const myApp(this.startWidget);

  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return HomeCubit();
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          home: AnimatedSplashScreen(
              splashIconSize: 180,
              duration: 4000,
              splash: Image(
                image: AssetImage('assets/logo1.png'),
              ),
              nextScreen: LoginPage(),
              splashTransition: SplashTransition.fadeTransition,
              backgroundColor: Color(0xFF92DF96)),
        ));
  }
}
