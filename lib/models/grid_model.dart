import 'package:flutter/material.dart';
import '../modules/about_app.dart';
import '../modules/opinion.dart';
import '../modules/posts/ads.dart';

class GridModel {
  String? title;
  String? image;
  Widget nav;
  GridModel({required this.title, required this.image, required this.nav});
}

List<GridModel> gridList = [
  GridModel(
      title: 'كتب للتبديل',
      image: 'assets/boarding4.png',
      nav: AllAds(
        title: 'كتب للتبديل',
        type: 'تبديل',
        fromAddPost: false,
      )),
  GridModel(
      title: 'كتب مجانية',
      image: 'assets/boarding3.png',
      nav: AllAds(
        title: 'كتب مجانية',
        type: 'تبرع',
        fromAddPost: false,
      )),
  GridModel(
      title: 'جميع الإعلانات',
      image: 'assets/boarding1.png',
      nav: AllAds(
        title: 'جميع الإعلانات',
        type: 'all',
        fromAddPost: false,
      )),
  GridModel(
      title: 'رأيك يهمنا',
      image: 'assets/boarding2.png',
      nav:  YourOpinion()),
  GridModel(
      title: 'نبذة عن التطبيق',
      image: 'assets/aboutgrid.gif',
      nav: const AboutApp()),
];
