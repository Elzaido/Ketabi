// ignore_for_file: camel_case_types, unused_local_variable, non_constant_identifier_names, prefer_const_constructors, unnecessary_string_interpolations, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/Cubit/home/home_cubit.dart';
import '../../shared/Cubit/home/home_state.dart';
import '../../shared/component.dart';
import '../../shared/constant.dart';

class Edit_Profile extends StatelessWidget {
  const Edit_Profile({Key? key}) : super(key: key);

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
        var UserModel = HomeCubit.get(context).userModel;

        var profileImage = HomeCubit.get(context).profileImage;

        final NameController = TextEditingController();
        final phoneController = TextEditingController();

        NameController.text = UserModel!.name!;
        phoneController.text = UserModel.phone!;

        return Scaffold(
            appBar: AppBar(
              title: Text(
                'تعديل الملف الشخصي',
                style: TextStyle(fontFamily: 'Cairo'),
              ),
            ),
            body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(children: [
                      Container(
                        height: 140,
                        child: Stack(children: [
                          const Align(
                            alignment: Alignment.bottomCenter,
                            child: CircleAvatar(
                              radius: 55.0,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 4.5),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Stack(children: [
                                profileImage == null
                                    ? CircleAvatar(
                                        radius: 50.0,
                                        backgroundImage:
                                            NetworkImage('${UserModel.image}'))
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
                                        icon: Icon(Icons.camera_alt_outlined)),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      formField(
                          control: NameController,
                          isScure: false,
                          label: 'Name',
                          prefIcon: Icon(Icons.person),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Name must not be empty';
                            } else {
                              return null;
                            }
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      formField(
                          control: phoneController,
                          isScure: false,
                          label: 'Phone',
                          prefIcon: Icon(Icons.phone),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Phone must not be empty';
                            } else {
                              return null;
                            }
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {
                              if (profileImage != null) {
                                HomeCubit.get(context).uploadProfileImage(
                                    name: NameController.text,
                                    phone: phoneController.text);
                              } else {
                                HomeCubit.get(context).updateUserData(
                                    name: NameController.text,
                                    phone: phoneController.text);
                              }
                            },
                            child: state is! LoadingUpdateUserState
                                ? Text(
                                    "حفظ التعديلات",
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                    ),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    color: mainColor,
                                    strokeWidth: 3,
                                  ))),
                      ),
                    ]))));
      },
    );
  }
}
