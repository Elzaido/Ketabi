// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'modules/on_boarding.dart';
import 'network/local/cache_helper.dart';
import 'phone.dart';
import 'shared/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Widget widget;
  if (onBoarding != null) {
    widget = MyPhone();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splashIconSize: 180,
        duration: 4000,
        splash: Image(
          image: AssetImage('assets/logo1.png'),
        ),
        nextScreen: MyPhone(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: mainColor,
      ),
    );
  }
}
