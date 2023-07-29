// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_const_literals_to_create_immutables, must_be_immutable
import 'package:book_swapping/shared/component.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../shared/Cubit/home/home_cubit.dart';
import 'ads.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  TextEditingController Search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          CarouselSlider(
              items: HomeCubit.get(context).images,
              options: CarouselOptions(
                height: 220.0,
                initialPage: 0,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              )),
          SizedBox(
            height: 10,
          ),
          defualtHomeItem(
            context: context,
            title: 'كتب للتبديل',
            image: 'assets/boarding4.png',
            onTap: () {
              HomeCubit.get(context).getPostsByType(type: 'تبديل');
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AllAds()));
            },
          ),
          defualtHomeItem(
            context: context,
            title: 'كتب للتبرع',
            image: 'assets/boarding2.png',
            onTap: () {
              HomeCubit.get(context).getPostsByType(type: 'تبرع');
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AllAds()));
            },
          ),
          defualtHomeItem(
            context: context,
            title: 'كتب للبيع',
            image: 'assets/boarding3.png',
            onTap: () {
              HomeCubit.get(context).getPostsByType(type: 'بيع');
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AllAds()));
            },
          ),
          defualtHomeItem(
            context: context,
            title: 'جميع الإعلانات',
            image: 'assets/boarding1.png',
            onTap: () {
              HomeCubit.get(context).getAllPosts();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AllAds()));
            },
          ),
          SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }
}
