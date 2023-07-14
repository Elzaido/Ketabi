// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/Cubit/home/home_cubit.dart';
import '../shared/Cubit/home/home_state.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: ((context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
                cubit.titles[cubit.currentIndex],
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 25,
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeNav(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline), label: 'حسابي'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.ad_units_sharp), label: 'إعلاناتي'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.post_add_outlined), label: 'أضف إعلان'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.chat_outlined), label: 'دردشاتي'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
              ]),
        );
      }),
    );
  }
}
