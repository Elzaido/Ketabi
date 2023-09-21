import 'package:book_swapping/modules/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/bourding_model.dart';
import '../network/local/cache_helper.dart';
import '../shared/component.dart';

// ignore: must_be_immutable
class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'assets/boarding1.png',
      title: 'بدل كتابك القديم',
    ),
    BoardingModel(
      image: 'assets/boarding3.png',
      title: 'إعرض كتاباً للبيع',
    ),
    BoardingModel(
      image: 'assets/boarding2.png',
      title: 'تبرع بكتابك للآخرين',
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            TextButton(
                onPressed: () {
                  submit();
                },
                child: const Text(
                  'تخطي',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    fontSize: 18,
                  ),
                )),
            const SizedBox(
              width: 5,
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Expanded(
                // PageView means that i have many pages in one page :
                child: PageView.builder(
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
                      boardingItemBuilder(boarding[index]),
                  itemCount: boarding.length,
                ),
              ),
              Row(
                children: [
                  SmoothPageIndicator(
                    controller: boardController,
                    count: boarding.length,
                    effect: const ExpandingDotsEffect(
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
              )
            ],
          ),
        ));
  }
}
