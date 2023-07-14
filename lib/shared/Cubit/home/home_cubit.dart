// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitHomeState());

  static HomeCubit get(context) => BlocProvider.of(context);
  File? profileImage;
  File? postImage;
  File? chatImage;

  int currentIndex = 4;

  List<String> titles = [
    'حسابي',
    'إعلاناتي',
    'أضف إعلان',
    'دردشاتي',
    'الرئيسية',
  ];

  List<Widget> images = [
    Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/Ad1.jpeg'))),
    ),
    Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/Ad2.jpeg'))),
    ),
    Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/Ad3.jpeg'))),
    ),
  ];

  void changeNav(int index) {
    if (index == 2) {
      emit(AddPostState());
    } else {
      currentIndex = index;
      emit(ChangeNavState());
    }
  }
}
