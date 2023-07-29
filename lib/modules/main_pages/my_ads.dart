// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables, must_be_immutable, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/Cubit/home/home_cubit.dart';
import '../../shared/Cubit/home/home_state.dart';
import '../../shared/component.dart';

class MyAds extends StatelessWidget {
  MyAds({Key? key}) : super(key: key);

  TextEditingController Search2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: formField(
                      control: Search2,
                      isScure: false,
                      label: 'إبحث في إعلاناتك ...',
                      prefIcon: Icon(Icons.search),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Name must not be empty';
                        } else {
                          return null;
                        }
                      }),
                ),
                ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: ((context, index) => AdItem(
                        context, HomeCubit.get(context).posts[index], true)),
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemCount: HomeCubit.get(context).posts.length),
              ],
            ),
          );
        });
  }
}
