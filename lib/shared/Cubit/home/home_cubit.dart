// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../modules/main_pages/add_post.dart';
import '../../../modules/main_pages/chats.dart';
import '../../../modules/main_pages/my_ads.dart';
import '../../../modules/main_pages/new_feeds.dart';
import '../../../modules/main_pages/profile.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitHomeState());

  static HomeCubit get(context) => BlocProvider.of(context);
  File? profileImage;
  File? postImage;
  File? chatImage;

  int currentIndex = 0;

  List<Widget> screens = [
    const Profile(),
    MyAds(),
    Add_Post(),
    const Chats(),
    NewFeeds(),
  ];

  List<String> titles = [
    'حسابي',
    'إعلاناتي',
    'أضف إعلان',
    'دردشاتي',
    'الرئيسية',
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
