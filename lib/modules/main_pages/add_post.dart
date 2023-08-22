// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/Cubit/home/home_cubit.dart';
import '../../shared/Cubit/home/home_state.dart';
import '../../shared/component.dart';
import '../../shared/constant.dart';

class Add_Post extends StatelessWidget {
  Add_Post({Key? key}) : super(key: key);

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(listener: (context, state) {
      if (state is SuccessUploadPostState) {
        defaultToast(
            massage: 'تم نشر الإعلان بنجاح', state: ToastStates.SUCCESS);
        HomeCubit.get(context).removePostImage();
        Navigator.pop(context);
      } else if (state is ErrorUploadPostState) {
        defaultToast(
            massage: 'هناك مشكلة في نشر الإعلان', state: ToastStates.ERROR);
      }
    }, builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
              title: Text(
                'أضف إعلاناً',
                style: TextStyle(fontFamily: 'Cairo'),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      if (HomeCubit.get(context).postImage == null) {
                        HomeCubit.get(context).createPost(
                            text: textController.text,
                            date: DateTime.now().toString(),
                            type: HomeCubit.get(context).selectedOption);
                      } else {
                        HomeCubit.get(context).uplaodPostImage(
                          text: textController.text,
                          date: DateTime.now().toString(),
                          type: HomeCubit.get(context).selectedOption,
                        );
                      }
                    },
                    child: const Text(
                      'إضافة',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontSize: 18),
                    )),
                SizedBox(
                  width: 7,
                ),
              ]),
          body: SingleChildScrollView(
            child: Column(
              children: [
                if (state is LoadingUploadPostState)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(),
                  ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(
                              '${HomeCubit.get(context).userModel!.image}')),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${HomeCubit.get(context).userModel!.name}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: formField(
                        control: textController,
                        isScure: false,
                        label: 'إسم الكتاب',
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'يجب إدخال إسم الكتاب';
                          } else {
                            return null;
                          }
                        },
                        prefIcon: Icon(Icons.book))),
                if (HomeCubit.get(context).postImage != null)
                  Stack(
                    children: [
                      Container(
                          height: 400,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0),
                              ),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                      HomeCubit.get(context).postImage!)))),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            backgroundColor: mainColor,
                            radius: 20,
                            child: IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  HomeCubit.get(context).removePostImage();
                                },
                                icon: Icon(Icons.close)),
                          ),
                        ),
                      ),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            HomeCubit.get(context).pickPostImage();
                          },
                          child: Center(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.photo),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'أضف صورة',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ]),
                          )),
                      SizedBox(
                        width: 30,
                      ),
                      Row(
                        children: [
                          DropdownButton(
                            iconSize: 40,
                            iconEnabledColor: Colors.blue,
                            focusColor: Colors.blue,
                            value: HomeCubit.get(context).selectedOption,
                            items: <String>['تبديل', 'بيع', 'تبرع']
                                .map<DropdownMenuItem<String>>(
                                  (String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ),
                                )
                                .toList(),
                            onChanged: (newValue) {
                              HomeCubit.get(context).selectPostType(newValue!);
                            },
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(':'),
                          Text(
                            'إختر نوع الإعلان',
                            style: TextStyle(fontFamily: 'Cairo'),
                          ),
                          SizedBox(
                            width: 15,
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ));
    });
  }
}
