// ignore_for_file: must_be_immutable
import 'package:book_swapping/shared/component.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../shared/Cubit/home/home_cubit.dart';
import 'posts/ads.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          CarouselSlider(
              items: HomeCubit.get(context).images,
              options: CarouselOptions(
                height: size.height * 0.30,
                initialPage: 0,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              )),
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
                            title: 'إعلانات التبديل',
                            type: 'تبديل',
                          )));
            },
          ),
          defualtHomeItem(
            context: context,
            title: 'كتب للتبرع',
            image: 'assets/boarding2.png',
            onTap: () {
              HomeCubit.get(context).getPostsByType(type: 'تبرع');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllAds(
                            title: 'إعلانات التبرع',
                            type: 'تبرع',
                          )));
            },
          ),
          defualtHomeItem(
            context: context,
            title: 'كتب للبيع',
            image: 'assets/boarding3.png',
            onTap: () {
              HomeCubit.get(context).getPostsByType(type: 'بيع');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllAds(
                            title: 'إعلانات البيع',
                            type: 'بيع',
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
