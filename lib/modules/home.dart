// ignore_for_file: must_be_immutable

import 'package:book_swapping/shared/component.dart';
import 'package:flutter/material.dart';
import '../shared/Cubit/home/home_cubit.dart';
import 'posts/ads.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
   

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          defualtHomeItem(
            context: context,
            title: 'كتب للتبديل',
            image: 'assets/boarding4.png',
            onTap: () {
              HomeCubit.get(context).getPostsByType(type: 'تبديل');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllAds(
                            title: 'كتب للتبديل',
                            type: 'تبديل',
                          )));
            },
          ),
          defualtHomeItem(
            context: context,
            title: 'كتب مجانية',
            image: 'assets/boarding2.png',
            onTap: () {
              HomeCubit.get(context).getPostsByType(type: 'تبرع');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllAds(
                            title: 'كتب مجانية',
                            type: 'تبرع',
                          )));
            },
          ),
          defualtHomeItem(
            context: context,
            title: 'جميع الإعلانات',
            image: 'assets/boarding1.png',
            onTap: () {
              HomeCubit.get(context).getAllPosts();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllAds(
                            title: 'جميع الإعلانات',
                            type: 'all',
                          )));
            },
          ),
          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }
}
