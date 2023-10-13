import 'package:book_swapping/modules/posts/add_post.dart';
import 'package:book_swapping/shared/component.dart';
import 'package:book_swapping/shared/constant.dart';
import 'package:flutter/material.dart';

import 'dialog_page1.dart';

class SelectPostType extends StatefulWidget {
  const SelectPostType({super.key});

  @override
  State<SelectPostType> createState() => _SelectPostTypeState();
}

class _SelectPostTypeState extends State<SelectPostType> {
  double textOpacity = 0.0;
  double image1Opacity = 0.0;
  double image2Opacity = 0.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        textOpacity = 1.0; // Set opacity to fully opaque (1.0) for fade-in.
      });
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        image1Opacity = 1.0; // Set opacity to fully opaque (1.0) for fade-in.
      });
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        image2Opacity = 1.0; // Set opacity to fully opaque (1.0) for fade-in.
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إختر نوع الإعلان',
          style: TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: textOpacity,
                duration: const Duration(milliseconds: 500),
                child: const Text(
                  'ما توع الإعلان الذي تريد نشره؟',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              AnimatedOpacity(
                  opacity: image1Opacity,
                  duration: const Duration(milliseconds: 500),
                  child: postTypeItem(
                      context: context,
                      nav: DialogPage1(),
                      image: 'assets/boarding3.png',
                      title: 'نشر إعلان للتبديل بكتاب')),
              const SizedBox(
                height: 30,
              ),
              AnimatedOpacity(
                  opacity: image2Opacity,
                  duration: const Duration(milliseconds: 500),
                  child: postTypeItem(
                      context: context,
                      nav: AddPost(
                        type: 'تبرع',
                      ),
                      image: 'assets/boarding2.png',
                      title: 'نشر إعلان للتبرع بكتاب')),
            ],
          ),
        ),
      ),
    );
  }
}
