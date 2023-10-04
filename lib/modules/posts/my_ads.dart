// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/Cubit/home/home_cubit.dart';
import '../../shared/Cubit/home/home_state.dart';
import '../../shared/component.dart';

class MyAds extends StatelessWidget {
  MyAds({Key? key}) : super(key: key);

  TextEditingController search2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(listener: (context, state) {
      if (state is SuccessDeletePostState) {
        defaultToast(
            massage: 'تم حذف الإعلان بنجاح', state: ToastStates.SUCCESS);
      } else if (state is ErrorDeletePostState) {
        defaultToast(
            massage: 'هناك مشكلة في حذف الإعلان', state: ToastStates.ERROR);
      }
    }, builder: (context, state) {
      return state is LoadingGetPostDataState
          ? loading()
          : HomeCubit.get(context).posts.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: ((context, index) => adItem(context,
                                HomeCubit.get(context).posts[index], true)),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 15),
                            itemCount: HomeCubit.get(context).posts.length),
                        const SizedBox(
                          height: 25,
                        )
                      ],
                    ),
                  ),
                )
              : const Center(
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
                      Icon(
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
