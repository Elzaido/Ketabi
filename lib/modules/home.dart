// ignore_for_file: must_be_immutable

import 'package:book_swapping/shared/component.dart';
import 'package:flutter/material.dart';
import '../models/grid_model.dart';

class Home extends StatelessWidget {
  Home({super.key});

  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: const Image(image: AssetImage('assets/yar.png'))),
          const SizedBox(
            height: 20,
          ),
          useActionGridView(context),
          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }

  Widget useActionGridView(context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1 / 1.35,
      children: gridList.map((item) {
        return gridItem(
            context: context,
            nav: item.nav,
            image: item.image!,
            title: item.title!);
      }).toList(),
    );
  }
}
