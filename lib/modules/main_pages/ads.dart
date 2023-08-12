// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables, must_be_immutable, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/Cubit/home/home_cubit.dart';
import '../../shared/Cubit/home/home_state.dart';
import '../../shared/component.dart';

class AllAds extends StatelessWidget {
  AllAds({super.key, required this.title});

  final String title;
  TextEditingController Search2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    child: formField(
                        control: Search2,
                        isScure: false,
                        label: 'إبحث عن ما تريد ...',
                        prefIcon: Icon(Icons.search),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'إبحث عن ما تريد ...';
                          } else {
                            return null;
                          }
                        }),
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: ((context, index) => adItem(context,
                          HomeCubit.get(context).posts[index], false, true)),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemCount: HomeCubit.get(context).posts.length),
                ],
              ),
            ),
          );
        });
  }
}
