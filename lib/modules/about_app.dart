import 'package:book_swapping/shared/constant.dart';
import 'package:flutter/material.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {

  double textOpacity = 0.0;
  double imageOpacity = 0.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        imageOpacity = 1.0; // Set opacity to fully opaque (1.0) for fade-in.
      });
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        textOpacity = 1.0; // Set opacity to fully opaque (1.0) for fade-in.
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'نبذة عن التطبيق',
          style: TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: imageOpacity,
              duration: const Duration(milliseconds: 500),
              child: gradientImage(
                image: 'assets/aboutApp.gif',
              ),
            ),
            AnimatedOpacity(
              opacity: textOpacity,
              duration: const Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  aboutAppText,
                  style: const TextStyle(fontSize: 16, fontFamily: 'Cairo'),
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

Widget gradientImage({
  required String image,
}) =>
    Stack(alignment: Alignment.bottomCenter, children: [
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.5), Colors.transparent],
          ),
        ),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      ),
      Container(
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.9),
                spreadRadius: 10,
                blurRadius: 30,
                offset: const Offset(
                    1, 40), // This controls the elevation from the top
              ),
            ],
          ),
          child: const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Center(
                child: Text(
                  '',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
      ),
    ]);


