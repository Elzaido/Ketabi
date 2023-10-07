import 'package:book_swapping/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../modules/posts/add_post.dart';
import '../shared/Cubit/home/home_cubit.dart';
import '../shared/Cubit/home/home_state.dart';

class HomeLayout extends StatelessWidget {
  final PageStorageBucket bucket = PageStorageBucket();

  HomeLayout({super.key});

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
                style: const TextStyle(
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
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 10,
            child: SizedBox(
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
                              Icons.person,
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
                              Icons.chat_outlined,
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
