// ignore_for_file: must_be_immutable

import 'package:book_swapping/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/Cubit/home/home_cubit.dart';
import '../../shared/Cubit/home/home_state.dart';
import '../../shared/component.dart';

class AllAds extends StatelessWidget {
  AllAds({super.key, required this.title, required this.type});

  final String title;
  final String type;

  TextEditingController search2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                ),
              ),
              backgroundColor: mainColor,
            ),
            body: state is LoadingGetPostDataState
                ? loading()
                : HomeCubit.get(context).posts.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: formField(
                                        control: search2,
                                        isScure: false,
                                        label: 'إبحث عن ما تريد ...',
                                        prefIcon: const Icon(Icons.search),
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'إبحث عن ما تريد ...';
                                          } else {
                                            return null;
                                          }
                                        }),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: button(
                                        onPressed: () {
                                          HomeCubit.get(context)
                                              .getPostsByTypeAndName(
                                                  type: type,
                                                  name: search2.text);
                                        },
                                        child: const Text(
                                          'بحث',
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 15,
                                          ),
                                        ),
                                        color: mainColor,
                                        height: 60),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: ((context, index) => adItem(
                                      context,
                                      HomeCubit.get(context).posts[index],
                                      false)),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 15),
                                  itemCount:
                                      HomeCubit.get(context).posts.length),
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
                              'لا يوجد إعلانات لعرضها',
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
                      ),
          );
        });
  }
}
