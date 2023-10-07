// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/Cubit/home/home_cubit.dart';
import '../../shared/Cubit/home/home_state.dart';
import '../../shared/component.dart';
import '../../shared/constant.dart';

class Add_Post extends StatelessWidget {
  Add_Post({Key? key}) : super(key: key);

  final bookNameController = TextEditingController();
  final bookPriceController = TextEditingController();
  final swappedBookCotroller = TextEditingController();
  final isbnNumberController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(listener: (context, state) {
      if (state is SuccessUploadPostState) {
        defaultToast(
            massage: 'تم نشر الإعلان بنجاح', state: ToastStates.SUCCESS);
        HomeCubit.get(context).removePostImage();
        bookNameController.text = '';
        swappedBookCotroller.text = '';
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
            backgroundColor: mainColor,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${HomeCubit.get(context).userModel!.name}',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(
                                '${HomeCubit.get(context).userModel!.image}')),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    dropDownTitle('عن ماذا تريد أن تعلن'),
                    dropDown(
                        selected: HomeCubit.get(context).selectedAdContentType,
                        list: HomeCubit.get(context).adContentTypes,
                        context: context,
                        dropDown: 2),
                    SizedBox(
                      height: 20,
                    ),
                    formField(
                        control: bookNameController,
                        isScure: false,
                        label:
                            'إسم ال${HomeCubit.get(context).selectedAdContentType}',
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'يجب إدخال الإسم';
                          } else {
                            return null;
                          }
                        },
                        prefIcon: Icon(Icons.book)),
                    SizedBox(
                      height: 20,
                    ),
                    if (HomeCubit.get(context).selectedAdContentType == 'كتاب')
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: formField(
                                control: isbnNumberController,
                                isScure: false,
                                label: 'ISPN of the book',
                                prefIcon: const Icon(Icons.search),
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'يجب إدخال الرقم';
                                  } else {
                                    return null;
                                  }
                                }),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: button(
                                onPressed: () {
                                  HomeCubit.get(context).fetchBookInfoByISBN(
                                      isbnNumberController.text.toString());
                                },
                                child: const Text(
                                  'بحث',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 15,
                                  ),
                                ),
                                color: mainColor,
                                height: 60),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    dropDownTitle('المجال أو الصنف'),
                    dropDown(
                        selected: HomeCubit.get(context).selectedAdCategory,
                        list: HomeCubit.get(context).adCategories,
                        context: context,
                        dropDown: 3),
                    SizedBox(
                      height: 20,
                    ),
                    dropDownTitle('نوع الإعلان'),
                    dropDown(
                        selected: HomeCubit.get(context).selectedAdType,
                        list: HomeCubit.get(context).adTypes,
                        context: context,
                        dropDown: 1),
                    SizedBox(
                      height: 20,
                    ),
                    if (HomeCubit.get(context).selectedAdType == 'تبديل')
                      formField(
                          control: swappedBookCotroller,
                          isScure: false,
                          label: 'بماذا تريد أن تبدل',
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'لا يجب أن يترك فارغاً';
                            } else {
                              return null;
                            }
                          },
                          prefIcon: Icon(Icons.book)),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                        onTap: () async {
                          showDialog(
                              context: context,
                              builder: (
                                context1,
                              ) =>
                                  AlertDialog(
                                      title: const Text(
                                        'أضف صورة',
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                      actions: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: button(
                                              //choosing image  from camera
                                              onPressed: () {
                                                HomeCubit.get(context)
                                                    .pickImageFromCamera();
                                                Navigator.pop(context);
                                              },
                                              color: mainColor,
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text('إلتقط صورة',
                                                      style: TextStyle(
                                                          fontFamily: 'Cairo')),
                                                  SizedBox(width: 5),
                                                  Icon(Icons.camera),
                                                ],
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: button(
                                              onPressed: () {
                                                HomeCubit.get(context)
                                                    .pickImageFromGallery();
                                                Navigator.pop(context);
                                              },
                                              color: mainColor,
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'إختر من المعرض',
                                                    style: TextStyle(
                                                        fontFamily: 'Cairo'),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Icon(Icons.image),
                                                ],
                                              )),
                                        ),
                                      ]));
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.green)),
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'أضف صورة',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontFamily: "Cairo",
                                  ),
                                ),
                                Icon(
                                  Icons.add_a_photo,
                                  color: Colors.green,
                                )
                              ],
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    if (HomeCubit.get(context).postImage != null)
                      Stack(
                        children: [
                          Container(
                              height: 400,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
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
                                    icon: Icon(
                                      Icons.close,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    button(
                        onPressed: () {
                          if (HomeCubit.get(context).postImage == null) {
                            HomeCubit.get(context).createPost(
                              bookName: bookNameController.text,
                              swapedBook: swappedBookCotroller.text,
                              date: DateTime.now().toString(),
                              adType: HomeCubit.get(context).selectedAdType,
                              adContentType:
                                  HomeCubit.get(context).selectedAdContentType,
                              category:
                                  HomeCubit.get(context).selectedAdCategory,
                            );
                          } else {
                            HomeCubit.get(context).uploadPostImage(
                              bookName: bookNameController.text,
                              swapedBook: swappedBookCotroller.text,
                              date: DateTime.now().toString(),
                              adType: HomeCubit.get(context).selectedAdType,
                              adContentType:
                                  HomeCubit.get(context).selectedAdContentType,
                              category:
                                  HomeCubit.get(context).selectedAdCategory,
                            );
                          }
                        },
                        child: Text(
                          'نشر',
                          style: TextStyle(fontFamily: 'Cairo'),
                        ),
                        color: mainColor),
                  ],
                ),
              ),
              if (state is LoadingUploadPostState) loading(),
            ],
          ));
    });
  }
}

Widget dropDown({
  required String selected,
  required List<String> list,
  required context,
  required int dropDown,
}) =>
    Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: DropdownButton(
            padding: const EdgeInsets.all(5),
            dropdownColor: const Color.fromARGB(255, 247, 247, 247),
            icon: const Icon(Icons.arrow_drop_down),
            isExpanded: true,
            iconSize: 22,
            style: const TextStyle(color: Colors.black, fontSize: 15),
            value: selected,
            underline: const SizedBox(),
            items: list.map((valueItem) {
              return DropdownMenuItem(
                  value: valueItem,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        valueItem,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ));
            }).toList(),
            onChanged: (newValue) {
              if (dropDown == 1) {
                HomeCubit.get(context).selectAdType(newValue!);
              } else if (dropDown == 2) {
                HomeCubit.get(context).selectAdContentType(newValue!);
              } else {
                HomeCubit.get(context).selectAdCategory(newValue!);
              }
            }));

Widget dropDownTitle(String title) {
  return Align(
    alignment: Alignment.centerRight,
    child: Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Cairo',
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
    ),
  );
}
