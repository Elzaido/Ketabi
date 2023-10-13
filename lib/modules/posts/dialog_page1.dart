import 'package:book_swapping/modules/posts/dialog_page2.dart';
import 'package:book_swapping/shared/Cubit/home/home_cubit.dart';
import 'package:book_swapping/shared/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/Cubit/home/home_state.dart';

class DialogPage1 extends StatelessWidget {
  DialogPage1({super.key});

  final myBookController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state)
    {
      return AlertDialog(
        title: const Text(
          'ما هو الكتاب الذي لديك و تريد أن تبدله؟',
          style: TextStyle(
            fontFamily: 'Cairo',
          ),
          textDirection: TextDirection.rtl,
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            dropDownTitle('النوع'),
            dropDown(
                selected: HomeCubit
                    .get(context)
                    .selectedAdContentType,
                list: HomeCubit
                    .get(context)
                    .adContentTypes,
                context: context,
                dropDown: 2),
            const SizedBox(
              height: 10,
            ),
            formField(
                control: myBookController,
                isScure: false,
                label:
                'أدخل إسم ال${HomeCubit
                    .get(context)
                    .selectedAdContentType}',
                prefIcon: const Icon(Icons.book),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'يجب إدخال الإسم';
                  } else {
                    return null;
                  }
                }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (myBookController.text.toString() == '') {
                defaultToast(
                  massage: 'يجب إدخال الإسم',
                  state: ToastStates.ERROR,
                );
              } else {
                Navigator.of(context).pop(); // Dismiss the first dialog
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DialogPage2(
                              myBookType:
                              HomeCubit
                                  .get(context)
                                  .selectedAdContentType,
                              myBook: myBookController.text.toString(),
                            )));
              }
            },
            child: const Text(
              'حسناً',
              style: TextStyle(
                fontFamily: 'Cairo',
              ),
            ),
          )
        ],
      );
    }) );
  }
}
