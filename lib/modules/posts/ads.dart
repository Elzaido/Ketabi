// ignore_for_file: must_be_immutable

import 'package:book_swapping/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/Cubit/home/home_cubit.dart';
import '../../shared/Cubit/home/home_state.dart';
import '../../shared/component.dart';
import 'add_post.dart';

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
                  : Padding(
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
                                      label: 'إبحث عن الكتاب الذي تريده ...',
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
                                                type: type, name: search2.text);
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
                              height: 10,
                            ),
                            InkWell(
                                onTap: () async {
                                  showFilteringDialog(
                                      context,
                                      type,
                                      HomeCubit.get(context)
                                          .selectedAdContentType,
                                      HomeCubit.get(context).selectedUniversity,
                                      HomeCubit.get(context)
                                          .selectedAdCategory);
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.green)),
                                  child: const Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'قم بفلترة نتائج البحث',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontFamily: "Cairo",
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.filter_alt,
                                          color: Colors.green,
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            HomeCubit.get(context).posts.isNotEmpty
                                ? ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: ((context, index) => adItem(
                                        context,
                                        HomeCubit.get(context).posts[index],
                                        false)),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 15),
                                    itemCount:
                                        HomeCubit.get(context).posts.length)
                                : const Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                          ],
                        ),
                      ),
                    ));
        });
  }
}

void showFilteringDialog(context, String type, String contentType,
    String university, String category) {
  showDialog(
      context: context,
      builder: (context1) => AlertDialog(
              title: const Text(
                'فلترة النتائج',
                style: TextStyle(
                  fontFamily: 'Cairo',
                ),
                textAlign: TextAlign.end,
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  dropDownTitle('النوع'),
                  dropDown(
                      selected: HomeCubit.get(context).selectedAdContentType,
                      list: HomeCubit.get(context).adContentTypes,
                      context: context,
                      dropDown: 2),
                  const SizedBox(
                    height: 5,
                  ),
                  dropDownTitle('الجامعة'),
                  dropDown(
                      selected: HomeCubit.get(context).selectedUniversity,
                      list: HomeCubit.get(context).universities,
                      context: context,
                      dropDown: 4),
                  const SizedBox(
                    height: 5,
                  ),
                  dropDownTitle('المجال أو الصنف'),
                  dropDown(
                      selected: HomeCubit.get(context).selectedAdCategory,
                      list: HomeCubit.get(context).adCategories,
                      context: context,
                      dropDown: 3),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
              actions: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          HomeCubit.get(context).getPostsByFilters(
                              type: type,
                              contentType: contentType,
                              university: university,
                              category: category);
                          Navigator.pop(context);
                        },
                        child: const Text('تأكيد',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                            )),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('إلغاء',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                            )),
                      ),
                    )
                  ],
                )
              ]));
}
