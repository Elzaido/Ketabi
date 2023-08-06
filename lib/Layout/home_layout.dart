// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:book_swapping/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import '../modules/main_pages/add_post.dart';
import '../shared/Cubit/home/home_cubit.dart';
import '../shared/Cubit/home/home_state.dart';

class HomeLayout extends StatelessWidget {
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: ((context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: mainColor,
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
          body: cubit.screens[cubit.currentIndex],
          floatingActionButton: FloatingActionButton(
            backgroundColor: mainColor,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Add_Post()));
            },
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 10,
            child: Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          HomeCubit.get(context).currentIndex = 0;
                          HomeCubit.get(context)
                              .changeNav(HomeCubit.get(context).currentIndex);
                          HomeCubit.get(context).getUserData();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Ionicons.person,
                              color: HomeCubit.get(context).currentIndex == 0
                                  ? mainColor
                                  : Colors.grey,
                            ),
                            Text(
                              'حسابي',
                              style: TextStyle(
                                color: HomeCubit.get(context).currentIndex == 0
                                    ? mainColor
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          HomeCubit.get(context).currentIndex = 1;
                          HomeCubit.get(context)
                              .changeNav(HomeCubit.get(context).currentIndex);
                          HomeCubit.get(context).getMyPosts(uId: uId!);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.ad_units,
                              color: HomeCubit.get(context).currentIndex == 1
                                  ? mainColor
                                  : Colors.grey,
                            ),
                            Text(
                              'إعلاناتي',
                              style: TextStyle(
                                color: HomeCubit.get(context).currentIndex == 1
                                    ? mainColor
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          HomeCubit.get(context).currentIndex = 3;
                          HomeCubit.get(context)
                              .changeNav(HomeCubit.get(context).currentIndex);
                          HomeCubit.get(context).getUserData();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Ionicons.chatbox,
                              color: HomeCubit.get(context).currentIndex == 3
                                  ? mainColor
                                  : Colors.grey,
                            ),
                            Text(
                              'دردشاتي',
                              style: TextStyle(
                                color: HomeCubit.get(context).currentIndex == 3
                                    ? mainColor
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          HomeCubit.get(context).currentIndex = 4;
                          HomeCubit.get(context)
                              .changeNav(HomeCubit.get(context).currentIndex);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home,
                              color: HomeCubit.get(context).currentIndex == 4
                                  ? mainColor
                                  : Colors.grey,
                            ),
                            Text(
                              'الرئيسية',
                              style: TextStyle(
                                color: HomeCubit.get(context).currentIndex == 4
                                    ? mainColor
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
