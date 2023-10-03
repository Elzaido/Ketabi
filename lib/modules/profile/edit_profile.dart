import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/Cubit/home/home_cubit.dart';
import '../../shared/Cubit/home/home_state.dart';
import '../../shared/component.dart';
import '../../shared/constant.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: ((context, state) {
        if (state is SuccessUpdateUserState) {
          defaultToast(
              massage: 'تم حفظ التعديلات بنجاح', state: ToastStates.SUCCESS);
        }
      }),
      builder: (context, state) {
        var userModel = HomeCubit.get(context).userModel;

        var profileImage = HomeCubit.get(context).profileImage;

        TextEditingController nameController = TextEditingController();
        TextEditingController phoneController = TextEditingController();
        TextEditingController emailController = TextEditingController();

        nameController.text = userModel!.name!;
        phoneController.text = userModel.phone!;
        emailController.text = userModel.email!;

        return Scaffold(
            appBar: AppBar(
              title: const Text(
                'تعديل الملف الشخصي',
                style: TextStyle(fontFamily: 'Cairo'),
              ),
              backgroundColor: mainColor,
            ),
            body: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.all(15),
                      physics: const BouncingScrollPhysics(),
                      child: Column(children: [
                        Stack(children: [
                          const Align(
                            alignment: Alignment.bottomCenter,
                            child: CircleAvatar(
                              radius: 55.0,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.5),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Stack(children: [
                                profileImage == null
                                    ? CircleAvatar(
                                        radius: 50.0,
                                        backgroundImage:
                                            NetworkImage(userModel.image))
                                    : CircleAvatar(
                                        radius: 50.0,
                                        backgroundImage:
                                            FileImage(profileImage)),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 57, left: 57),
                                  child: CircleAvatar(
                                    radius: 20,
                                    child: IconButton(
                                        onPressed: () {
                                          HomeCubit.get(context)
                                              .pickProfileImage();
                                        },
                                        icon: const Icon(
                                            Icons.camera_alt_outlined)),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ]),
                        const SizedBox(
                          height: 20,
                        ),
                        formField(
                            control: nameController,
                            isScure: false,
                            label: 'الإسم',
                            prefIcon: const Icon(Icons.person),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'لا يجب أن يترك الإسم فارغاً';
                              } else {
                                return null;
                              }
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        formField(
                            control: phoneController,
                            isScure: false,
                            label: 'رقم الهاتف',
                            prefIcon: const Icon(Icons.phone),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'لا يجب أن يترك رقم الهاتف فارغاً';
                              } else {
                                return null;
                              }
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        formField(
                            control: emailController,
                            isScure: false,
                            label: 'البريد الإلكتروني',
                            prefIcon: const Icon(Icons.email),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'لا يجب أن يترك البريد الإلكتروني فارغاً';
                              } else {
                                return null;
                              }
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        button(
                            onPressed: () {
                              if (profileImage != null) {
                                HomeCubit.get(context).uploadProfileImage(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    email: emailController.text);
                              } else {
                                HomeCubit.get(context).updateUserData(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    email: emailController.text);
                              }
                            },
                            child: const Text(
                              "حفظ التعديلات",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                              ),
                            ),
                            color: mainColor),
                      ])),
                ),
                if (state is LoadingUpdateUserState) loading(),
              ],
            ));
      },
    );
  }
}
