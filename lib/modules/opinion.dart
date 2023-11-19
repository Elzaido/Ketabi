import 'package:book_swapping/shared/Cubit/home/home_cubit.dart';
import 'package:book_swapping/shared/Cubit/home/home_state.dart';
import 'package:book_swapping/shared/component.dart';
import 'package:book_swapping/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class YourOpinion extends StatelessWidget {
  YourOpinion({super.key});

  final opinionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(listener: (context, state) {
      if (state is SuccessUploadOpinion) {
        opinionController.text = '';
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'رأيك يهمنا',
            style: TextStyle(
              fontFamily: 'Cairo',
            ),
          ),
          backgroundColor: mainColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            children: [
              SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      descFormField(
                          hint: 'أخبرنا برأيك في تطبيق كتابي',
                          textController: opinionController),
                      const SizedBox(
                        height: 20,
                      ),
                      button(
                          onPressed: () {
                            if (opinionController.text == '') {
                              defaultToast(
                                  massage: 'لا يمكن إرسال الرأي فارغاً',
                                  state: ToastStates.ERROR);
                            } else {
                              HomeCubit.get(context).createOpinion(
                                  opinion: opinionController.text);
                            }
                          },
                          child: const Text(
                            'إرسال',
                            style: TextStyle(fontFamily: 'Cairo'),
                          ),
                          color: mainColor),
                    ],
                  )),
              if (state is LoadingUploadOpinion) loading(),
            ],
          ),
        ),
      );
    });
  }
}

Widget descFormField({
  required String hint,
  required TextEditingController textController,
}) =>
    Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: textController,
        textDirection: TextDirection.rtl,
        maxLines: 5,
        autofocus: false,
        decoration: InputDecoration(
            hintText: hint,
            hintTextDirection: TextDirection.rtl,
            hintStyle: const TextStyle(
              fontFamily: 'Cairo',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )
            // Add border styling
            ),
      ),
    );
