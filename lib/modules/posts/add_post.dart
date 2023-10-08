import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/Cubit/home/home_cubit.dart';
import '../../shared/Cubit/home/home_state.dart';
import '../../shared/component.dart';
import '../../shared/constant.dart';

class AddPost extends StatelessWidget {
  AddPost({Key? key}) : super(key: key);

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
        HomeCubit.get(context).bookTitle = '';
        HomeCubit.get(context).author = '';
        HomeCubit.get(context).publisher = '';
      } else if (state is ErrorUploadPostState) {
        defaultToast(
            massage: 'هناك مشكلة في نشر الإعلان', state: ToastStates.ERROR);
      }
    }, builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            title: const Text(
              'أضف إعلاناً',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: mainColor,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${HomeCubit.get(context).userModel!.name}',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(
                                HomeCubit.get(context).userModel!.image)),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    dropDownTitle('عن ماذا تريد أن تعلن'),
                    dropDown(
                        selected: HomeCubit.get(context).selectedAdContentType,
                        list: HomeCubit.get(context).adContentTypes,
                        context: context,
                        dropDown: 2),
                    const SizedBox(
                      height: 20,
                    ),
                    if (HomeCubit.get(context).selectedAdContentType ==
                            'دوسية' ||
                        HomeCubit.get(context).selectedAdContentType ==
                            'سلايدات')
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
                          prefIcon: const Icon(Icons.book)),
                    const SizedBox(
                      height: 20,
                    ),
                    if (HomeCubit.get(context).selectedAdContentType == 'كتاب')
                      Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showISBNInfoDialog(context);
                                  },
                                  icon: const Icon(
                                    Icons.help,
                                    color: Colors.grey,
                                  )),
                              Expanded(
                                child: InkWell(
                                    onTap: () async {
                                      showISBNDialog(
                                          context, isbnNumberController);
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.green)),
                                      child: const Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'ISBN',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontFamily: "Cairo",
                                              ),
                                            ),
                                            Text(
                                              'أضف رقم ال',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontFamily: "Cairo",
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.numbers,
                                              color: Colors.green,
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (HomeCubit.get(context).bookTitle.isNotEmpty)
                            infoItems(
                                title: 'عنوان الكتاب',
                                info: HomeCubit.get(context).bookTitle),
                          const SizedBox(
                            height: 10,
                          ),
                          if (HomeCubit.get(context).author.isNotEmpty)
                            infoItems(
                                title: 'المؤلف',
                                info: HomeCubit.get(context).author),
                          const SizedBox(
                            height: 10,
                          ),
                          if (HomeCubit.get(context).publisher.isNotEmpty)
                            infoItems(
                                title: 'الناشر',
                                info: HomeCubit.get(context).publisher),
                        ],
                      ),
                    if (HomeCubit.get(context).selectedAdContentType == 'كتاب')
                      const SizedBox(
                        height: 20,
                      ),
                    dropDownTitle('الجامعة'),
                    dropDown(
                        selected: HomeCubit.get(context).selectedUniversity,
                        list: HomeCubit.get(context).universities,
                        context: context,
                        dropDown: 4),
                    const SizedBox(
                      height: 20,
                    ),
                    dropDownTitle('المجال أو الصنف'),
                    dropDown(
                        selected: HomeCubit.get(context).selectedAdCategory,
                        list: HomeCubit.get(context).adCategories,
                        context: context,
                        dropDown: 3),
                    const SizedBox(
                      height: 20,
                    ),
                    dropDownTitle('نوع الإعلان'),
                    dropDown(
                        selected: HomeCubit.get(context).selectedAdType,
                        list: HomeCubit.get(context).adTypes,
                        context: context,
                        dropDown: 1),
                    const SizedBox(
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
                          prefIcon: const Icon(Icons.book)),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                        onTap: () async {
                          showImageDialog(context);
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
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.add_a_photo,
                                  color: Colors.green,
                                )
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(
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
                                    icon: const Icon(
                                      Icons.close,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    button(
                        onPressed: () {
                          if (HomeCubit.get(context).postImage == null) {
                            HomeCubit.get(context).createPost(
                              contentName: bookNameController.text,
                              university:
                                  HomeCubit.get(context).selectedUniversity,
                              bookName: HomeCubit.get(context).bookTitle,
                              bookAuthor: HomeCubit.get(context).author,
                              bookPublisher: HomeCubit.get(context).publisher,
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
                              contentName: bookNameController.text,
                              university:
                                  HomeCubit.get(context).selectedUniversity,
                              bookName: HomeCubit.get(context).bookTitle,
                              bookAuthor: HomeCubit.get(context).author,
                              bookPublisher: HomeCubit.get(context).publisher,
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
                        child: const Text(
                          'نشر',
                          style: TextStyle(fontFamily: 'Cairo'),
                        ),
                        color: mainColor),
                  ],
                ),
              ),
              if (state is LoadingUploadPostState || state is LoadingFetchISBN)
                loading(),
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
              } else if (dropDown == 3) {
                HomeCubit.get(context).selectAdCategory(newValue!);
              } else {
                HomeCubit.get(context).selectUniversity(newValue!);
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

void showImageDialog(context) {
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: button(
                      //choosing image  from camera
                      onPressed: () {
                        HomeCubit.get(context).pickImageFromCamera();
                        Navigator.pop(context);
                      },
                      color: mainColor,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('إلتقط صورة',
                              style: TextStyle(fontFamily: 'Cairo')),
                          SizedBox(width: 5),
                          Icon(Icons.camera),
                        ],
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: button(
                      onPressed: () {
                        HomeCubit.get(context).pickImageFromGallery();
                        Navigator.pop(context);
                      },
                      color: mainColor,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'إختر من المعرض',
                            style: TextStyle(fontFamily: 'Cairo'),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(Icons.image),
                        ],
                      )),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('إلغاء',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                        )),
                  ),
                ),
              ]));
}

void showISBNDialog(context, TextEditingController isbnController) {
  showDialog(
      context: context,
      builder: (context1) => AlertDialog(
              title: const Text(
                'ISBN',
                style: TextStyle(
                  fontFamily: 'Cairo',
                ),
                textAlign: TextAlign.end,
              ),
              actions: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: button(
                      //choosing image  from camera
                      onPressed: () {
                        HomeCubit.get(context).scanBarcode();
                        Navigator.pop(context);
                      },
                      color: mainColor,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('إمسح الكود من الكاميرا',
                              style: TextStyle(fontFamily: 'Cairo')),
                          SizedBox(width: 5),
                          Icon(Icons.camera),
                        ],
                      )),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: formField(
                      control: isbnController,
                      isScure: false,
                      label: 'أو قم بإدخال الرقم يدوياً',
                      prefIcon: const Icon(Icons.numbers),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'لا يجب أن يترك فارغاً';
                        } else {
                          return null;
                        }
                      },
                    )),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          HomeCubit.get(context).fetchBookInfoByISBN(
                              isbnController.text.toString());
                          Navigator.pop(context);
                        },
                        child: const Text('تأكيد',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                            )),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('إلغاء',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                            )),
                      ),
                    )
                  ],
                )
              ]));
}

void showISBNInfoDialog(context) {
  showDialog(
      context: context,
      builder: (context1) => AlertDialog(
              title: const Text(
                'ISBN info',
                style: TextStyle(
                  fontFamily: 'Cairo',
                ),
                textAlign: TextAlign.end,
              ),
              content: const Image(image: AssetImage('assets/isbn.png')),
              actions: <Widget>[
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('فهمت',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                        )),
                  ),
                ),
              ]));
}
