import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/Cubit/home/home_cubit.dart';
import '../../shared/Cubit/home/home_state.dart';
import '../../shared/component.dart';
import 'ads.dart';

class DialogPage2 extends StatelessWidget {
  DialogPage2({super.key, required this.myBook, required this.myBookType});

  final String myBookType;
  final String myBook;
  final theirBookController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state)
    {
      return AlertDialog(
        title: const Text(
          'بماذا تريد أن تبدل؟',
          style: TextStyle(fontFamily: 'Cairo'),
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
                    .selectedSwapAdContentType,
                list: HomeCubit
                    .get(context)
                    .adSwapContentTypes,
                context: context,
                dropDown: 5),
            const SizedBox(
              height: 10,
            ),
            formField(
                control: theirBookController,
                isScure: false,
                label:
                'أدخل إسم ال${HomeCubit
                    .get(context)
                    .selectedSwapAdContentType}',
                prefIcon: const Icon(Icons.book),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'يجب إدخال الإسم ';
                  } else {
                    return null;
                  }
                }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (theirBookController.text.toString() == '') {
                defaultToast(
                  massage: 'يجب إدخال إسم الكتاب',
                  state: ToastStates.ERROR,
                );
              } else {
                Navigator.of(context).pop(); // Dismiss the second dialog
                HomeCubit.get(context).getSpecificPosts(
                  myBook: myBook,
                  myContentType: myBookType,
                  swapBook: theirBookController.text.toString(),
                  adContentType:
                  HomeCubit
                      .get(context)
                      .selectedSwapAdContentType,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AllAds(
                          title: 'إعلانات للتبديل',
                          type: 'تبديل',
                          fromAddPost: true,
                        ),
                  ),
                );
              }
            },
            child: const Text(
              'حسناً',
              style: TextStyle(
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      );
    }));
  }
}
