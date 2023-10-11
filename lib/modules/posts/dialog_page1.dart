import 'package:book_swapping/modules/posts/dialog_page2.dart';
import 'package:book_swapping/shared/component.dart';
import 'package:flutter/material.dart';

class DialogPage1 extends StatelessWidget {
  DialogPage1({super.key});

  final myBookController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog(
        title: const Text('ما هو الكتاب الذي لديك و تريد أن تبدله؟'),
        content: formField(
            control: myBookController,
            isScure: false,
            label: 'أدخل إسم الكتاب',
            prefIcon: const Icon(Icons.book),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'يجب إدخال إسم الكتاب';
              } else {
                return null;
              }
            }),
        actions: [
          TextButton(
            onPressed: () {
              if (myBookController.text.toString() == '') {
                defaultToast(
                  massage: 'يجب إدخال إسم الكتاب',
                  state: ToastStates.ERROR,
                );
              } else {
                Navigator.of(context).pop(); // Dismiss the first dialog
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DialogPage2(
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
      ),
    );
  }
}
