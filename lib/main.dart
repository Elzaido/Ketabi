import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:book_swapping/modules/authentication/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Layout/home_layout.dart';
//import 'firebase_messeging.dart';
import 'firebase_options.dart';
import 'modules/on_boarding.dart';
import 'network/local/cache_helper.dart';
import 'shared/Cubit/home/home_cubit.dart';
import 'shared/bloc_observer.dart';
import 'shared/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  uId = CacheHelper.getData(key: 'uId');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 // initFirebaseMessaging();
  Widget widget;
  if (onBoarding != null) {
    if (uId != null) {
      widget = HomeLayout();
    } else {
      widget = const LoginPage();
    }
  } else {
    widget = const OnBoarding();
  }
  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.startWidget});

  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return HomeCubit()
            ..getUsers()
            ..getUserData();
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AnimatedSplashScreen(
              splashIconSize: 180,
              duration: 4000,
              animationDuration: const Duration(milliseconds: 1000),
              splash: const Image(
                image: AssetImage('assets/logo1.png'),
              ),
              nextScreen: startWidget,
              splashTransition: SplashTransition.fadeTransition,
              backgroundColor: const Color(0xFF92DF96)),
        ));
  }
}
