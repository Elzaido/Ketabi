import 'package:book_swapping/modules/posts/select_post_type.dart';
import './../authentication/login.dart';
import './../profile/favorite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../network/local/cache_helper.dart';
import '../../shared/Cubit/home/home_cubit.dart';
import '../../shared/Cubit/home/home_state.dart';
import '../../shared/component.dart';
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
            SizedBox(
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
              child: Card(
                color: const Color.fromARGB(255, 243, 243, 243),
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
                        icon: const Icon(Icons.edit),
                        text: 'تعديل الملف الشخصي'),
                    separator(),
                    profileButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectPostType()));
                        },
                        text: 'إضافة إعلان',
                        icon: const Icon(Icons.add)),
                    separator(),
                    profileButton(
                        onPressed: () {
                          HomeCubit.get(context).changeNav(1);
                        },
                        text: 'إعلاناتي',
                        icon: const Icon(Icons.ad_units)),
                    separator(),
                    profileButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Favorites()));
                        },
                        text: 'الإعلانات المفضلة',
                        icon: const Icon(Icons.favorite_border)),
                    separator(),
                    profileButton(
                        onPressed: () {
                          CacheHelper.removeData(key: 'uId').then((value) {
                            if (value) {
                              FirebaseAuth.instance.signOut().then((_) {
                                navigateAndFinish(
                                    context: context,
                                    widget: const LoginPage());
                                HomeCubit.get(context).changeNav(4);
                              }).catchError((error) {
                                // Handle the sign-out error, e.g., display an error message.
                                print("Sign-out error: $error");
                              });
                            }
                          });
                        },
                        text: 'تسجيل الخروج',
                        icon: const Icon(Icons.logout)),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ]),
        );
      },
    );
  }
}
