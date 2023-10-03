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
    return BlocConsumer<HomeCubit, HomeStates>(listener: (context, state) {
      if (state is SuccessDeletePostState) {
        defaultToast(
            massage: 'تم حذف الإعلان بنجاح', state: ToastStates.SUCCESS);
      } else if (state is ErrorDeletePostState) {
        defaultToast(
            massage: 'هناك مشكلة في حذف الإعلان بنجاح',
            state: ToastStates.ERROR);
      }
    }, builder: (context, state) {
      return HomeCubit.get(context).posts.isNotEmpty
          ? SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: formField(
                        control: Search2,
                        isScure: false,
                        label: 'إبحث في إعلاناتك ...',
                        prefIcon: Icon(Icons.search),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'إبحث في إعلاناتك ...';
                          } else {
                            return null;
                          }
                        }),
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: ((context, index) => myAdItem(
                            context,
                            HomeCubit.get(context).posts[index],
                          )),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemCount: HomeCubit.get(context).posts.length),
                  SizedBox(
                    height: 25,
                  )
                ],
              ),
            )
          : Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '!',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'لا يوجد لديك إعلانات لعرضها',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  const Icon(
                    Icons.warning,
                    color: Colors.red,
                    size: 35,
                  )
                ],
              ),
            );
    });
  }
}
