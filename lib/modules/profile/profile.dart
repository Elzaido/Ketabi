// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:book_swapping/modules/authentication/login.dart';
import 'package:book_swapping/modules/profile/favorite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../network/local/cache_helper.dart';
import '../../shared/Cubit/home/home_cubit.dart';
import '../../shared/Cubit/home/home_state.dart';
import '../../shared/component.dart';
import '../main_pages/add_post.dart';
import 'edit_profile.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(children: [
            Container(
              height: 140,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  backgroundImage:
                      NetworkImage(HomeCubit.get(context).userModel!.image),
                  radius: 50,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${HomeCubit.get(context).userModel!.name}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
              child: Card(
                color: Color.fromARGB(255, 243, 243, 243),
                elevation: 5,
                child: Column(
                  children: [
                    profileButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EditProfile()),
                          );
                        },
                        icon: Icon(Icons.edit),
                        text: 'تعديل الملف الشخصي'),
                    separator(),
                    profileButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Add_Post()));
                        },
                        text: 'إضافة إعلان',
                        icon: Icon(Icons.add)),
                    separator(),
                    profileButton(
                        onPressed: () {
                          HomeCubit.get(context).changeNav(1);
                        },
                        text: 'إعلاناتي',
                        icon: Icon(Icons.ad_units)),
                    separator(),
                    profileButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Favorites()));
                        },
                        text: 'الإعلانات المفضلة',
                        icon: Icon(Icons.favorite_border)),
                    separator(),
                    profileButton(
                        onPressed: () {
                          CacheHelper.removeData(key: 'uId').then((value) {
                            if (value) {
                              navigateAndFinish(
                                  context: context, widget: LoginPage());
                              FirebaseAuth.instance.signOut();
                              HomeCubit.get(context).changeNav(4);
                            }
                          });
                        },
                        text: 'تسجيل الخروج',
                        icon: Icon(Icons.logout)),
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
