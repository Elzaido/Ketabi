import 'package:book_swapping/shared/constant.dart';
import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

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
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(
                'assets/logo.png',
              ),
              color: Colors.white,
            ),
            Text('data'),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
