// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../../shared/Cubit/home/home_cubit.dart';
import '../../shared/component.dart';

class Chats extends StatelessWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeCubit.get(context).users.isNotEmpty
        ? SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: ((context, index) =>
                    (chatItem(context, HomeCubit.get(context).users[index]))),
                separatorBuilder: ((context, index) => separator()),
                itemCount: HomeCubit.get(context).users.length),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
