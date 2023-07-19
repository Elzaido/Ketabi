// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/Cubit/home/home_cubit.dart';
import '../../shared/Cubit/home/home_state.dart';

class Add_Post extends StatelessWidget {
  Add_Post({Key? key}) : super(key: key);

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  'أضف إعلاناً',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
                // actions: [
                //   TextButton(
                //       onPressed: () {
                //         if (HomeCubit.get(context).postImage == null) {
                //           HomeCubit.get(context).createPost(
                //               text: textController.text,
                //               date: DateTime.now().toString());
                //         } else {
                //           HomeCubit.get(context).uplaodPostImage(
                //             text: textController.text,
                //             date: DateTime.now().toString(),
                //           );
                //         }
                //       },
                //       child: const Text(
                //         'إضافة',
                //         style: TextStyle(
                //             fontFamily: 'Cairo',
                //             color: Colors.white,
                //             fontSize: 18),
                //       )),
                //   SizedBox(
                //     width: 7,
                //   ),
                // ]
              ),
              body: Column(
                children: [
                  // if (state is LoadingUploadPostState)
                  //   Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: LinearProgressIndicator(),
                  //   ),
                  // Padding(
                  //   padding: EdgeInsets.all(15.0),
                  //   child: Row(
                  //     children: [
                  //       CircleAvatar(
                  //           radius: 30.0,
                  //           backgroundImage: NetworkImage(
                  //               '${HomeCubit.get(context).userModel!.image}')),
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       Text(
                  //         '${HomeCubit.get(context).userModel!.name}',
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 15,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: TextFormField(
                      textDirection: TextDirection.rtl,
                      controller: textController,
                      decoration: InputDecoration(
                          hintText: 'أكتب هنا ...',
                          hintTextDirection: TextDirection.rtl,
                          border: InputBorder.none),
                    ),
                  )),
                  if (HomeCubit.get(context).postImage != null)
                    Stack(
                      children: [
                        Container(
                            height: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5.0),
                                  topRight: Radius.circular(5.0),
                                ),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(
                                        HomeCubit.get(context).postImage!)))),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Align(
                        //     alignment: Alignment.topRight,
                        //     child: CircleAvatar(
                        //       radius: 20,
                        //       child: IconButton(
                        //           onPressed: () {
                        //             HomeCubit.get(context).removePostImage();
                        //           },
                        //           icon: Icon(Icons.close)),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 10),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: TextButton(
                  //             onPressed: () {
                  //               HomeCubit.get(context).pickPostImage();
                  //             },
                  //             child: Center(
                  //               child: Row(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   children: [
                  //                     Icon(Icons.photo),
                  //                     SizedBox(
                  //                       width: 5,
                  //                     ),
                  //                     Text(
                  //                       'أضف صورة',
                  //                       style: TextStyle(
                  //                         fontFamily: 'Cairo',
                  //                       ),
                  //                     ),
                  //                   ]),
                  //             )),
                  //       ),
                  //       Expanded(
                  //         child: TextButton(
                  //           onPressed: () {},
                  //           child: Center(
                  //               child: Text(
                  //             '# هاشتاغ',
                  //             style: TextStyle(
                  //               fontFamily: 'Cairo',
                  //             ),
                  //           )),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // )
                ],
              ));
        });
  }
}
