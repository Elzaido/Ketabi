import 'package:book_swapping/modules/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/bourding_model.dart';
import '../network/local/cache_helper.dart';
import '../shared/component.dart';

// ignore: must_be_immutable
class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'assets/boarding1.png',
      title: 'تسهيل عمليات تبادل الكتب و التبرع بها',
    ),
    BoardingModel(
      image: 'assets/boarding2.png',
      title: 'شارك معنا في نشر العلم',
    ),
    BoardingModel(
      image: 'assets/boarding3.png',
      title: 'تبرع بالكتب التي لم تعد بحاجتها',
    ),
    BoardingModel(
      image: 'assets/boarding4.png',
      title: 'بدل كتابك بكتابٍ آخر',
    ),
  ];

  void submit() {
    CacheHelper.saveDate(key: 'onBoarding', value: true).then((value) {
      if (value) {
        navigateAndFinish(context: context, widget: const LoginPage());
      }
    });
  }

  var boardController = PageController();
  bool isLast = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(
      children: [
        PageView.builder(
          physics: const BouncingScrollPhysics(),
          controller: boardController,
          onPageChanged: (int index) {
            // if the index equal the index of the last page then :
            if (index == boarding.length - 1) {
              setState(() {
                isLast = true;
              });
            } else {
              setState(() {
                isLast = false;
              });
            }
          },
          itemBuilder: (context, index) =>
              boardingItemBuilder(boarding[index], size),
          itemCount: boarding.length,
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: TextButton(
                onPressed: () {
                  submit();
                },
                child: const Text(
                  'تخطي',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    fontSize: 20,
                  ),
                )),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    SmoothPageIndicator(
                      controller: boardController,
                      count: boarding.length,
                      effect: const ExpandingDotsEffect(
                        dotColor: Colors.white,
                        activeDotColor: Colors.green,
                        dotHeight: 10,
                        dotWidth: 10,
                        expansionFactor: 4,
                        spacing: 5,
                      ),
                    ),
                    const Spacer(),
                    FloatingActionButton(
                        backgroundColor: Colors.green,
                        onPressed: () {
                          if (isLast) {
                            submit();
                          } else {
                            boardController.nextPage(
                                duration: const Duration(
                                  milliseconds: 750,
                                ),
                                curve: Curves.fastLinearToSlowEaseIn);
                          }
                        },
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ))
                  ],
                )))
      ],
    ));
  }
}
