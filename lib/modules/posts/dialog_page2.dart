import 'package:flutter/material.dart';

import '../../shared/component.dart';
import 'ads.dart';

class DialogPage2 extends StatelessWidget {
  DialogPage2({super.key, required this.myBook});

  final String myBook;
  final theirBookController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog(
        title: const Text(
          'بماذا تريد أن تبدل؟',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        content: formField(
            control: theirBookController,
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
              if (theirBookController.text.toString() == '') {
                defaultToast(
                  massage: 'يجب إدخال إسم الكتاب',
                  state: ToastStates.ERROR,
                );
              } else {
                Navigator.of(context).pop(); // Dismiss the second dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllAds(
                      title: 'إعلانات للتبديل',
                      type: 'تبديل',
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
      ),
    );
  }
}
