// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/Cubit/home/home_cubit.dart';
import '../../shared/Cubit/home/home_state.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(children: [
            // Container(
            //   height: 140,
            //   child: Padding(
            //     padding: const EdgeInsets.all(10.0),
            //     child: CircleAvatar(
            //       backgroundImage: NetworkImage(
            //           '${HomeCubit.get(context).userModel!.image}'),
            //       radius: 50,
            //     ),
            //   ),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       '${HomeCubit.get(context).userModel!.name}',
            //       style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //         fontSize: 20,
            //       ),
            //     ),
            //     SizedBox(
            //       width: 5,
            //     ),
            //     Icon(
            //       Icons.verified,
            //       color: Colors.blue,
            //       size: 20,
            //     )
            //   ],
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '100',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'إعلان',
                          style: TextStyle(
                              color: Colors.grey, fontFamily: 'Cairo'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '70',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'النقرات',
                          style: TextStyle(
                              color: Colors.grey, fontFamily: 'Cairo'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '1K',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'مشاهدات',
                          style: TextStyle(
                              color: Colors.grey, fontFamily: 'Cairo'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
              child: Card(
                color: Color.fromARGB(255, 243, 243, 243),
                elevation: 5,
                child: Column(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       Expanded(
                    //         child: TextButton(
                    //             onPressed: () {
                    //               Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                     builder: (context) =>
                    //                         const Edit_Profile()),
                    //               );
                    //             },
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.end,
                    //               children: [
                    //                 Text(
                    //                   'تعديل الملف الشخصي',
                    //                   style: TextStyle(
                    //                     fontFamily: 'Cairo',
                    //                   ),
                    //                 ),
                    //                 SizedBox(
                    //                   width: 20,
                    //                 ),
                    //                 Icon(Icons.edit)
                    //               ],
                    //             )),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        height: 1,
                        color: Color.fromARGB(255, 82, 82, 82),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextButton(
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'إضافة إعلان',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Icon(Icons.add)
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        height: 1,
                        color: Color.fromARGB(255, 82, 82, 82),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextButton(
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'إعلاناتي',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Icon(Icons.ad_units)
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        height: 1,
                        color: Color.fromARGB(255, 82, 82, 82),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextButton(
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'الإعلانات المفضلة',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Icon(Icons.favorite_border)
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        height: 1,
                        color: Color.fromARGB(255, 82, 82, 82),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       Expanded(
                    //         child: TextButton(
                    //             onPressed: () {
                    //               CacheHelper.removeData(key: 'uId')
                    //                   .then((value) {
                    //                 if (value) {
                    //                   navigateAndFinish(
                    //                       context: context,
                    //                       widget: LoginScreen());
                    //                 }
                    //               });
                    //               HomeCubit().currentIndex = 4;
                    //             },
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.end,
                    //               children: [
                    //                 Text(
                    //                   'تسجيل الخروج',
                    //                   style: TextStyle(
                    //                     fontFamily: 'Cairo',
                    //                   ),
                    //                 ),
                    //                 SizedBox(
                    //                   width: 20,
                    //                 ),
                    //                 Icon(Icons.logout)
                    //               ],
                    //             )),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          ]),
        );
      },
    );
  }
}
