// ignore_for_file: prefer_const_constructors, must_be_immutable, curly_braces_in_flow_control_structures, unnecessary_null_comparison

import 'package:book_swapping/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/chat_model.dart';
import '../../shared/Cubit/home/home_cubit.dart';
import '../../shared/Cubit/home/home_state.dart';

class ChatDetails extends StatelessWidget {
  final String uId;
  final String image;
  final String name;
  final String fToken;

  ChatDetails(
      {Key? key,
      required this.uId,
      required this.image,
      required this.name,
      required this.fToken})
      : super(key: key);

  var messageCotroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      HomeCubit.get(context).getMessages(receiverId: uId);

      return BlocConsumer<HomeCubit, HomeStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: mainColor,
                  titleSpacing: 0.0,
                  title: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: CircleAvatar(
                            radius: 22.0, backgroundImage: NetworkImage(image)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          reverse: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var message = HomeCubit.get(context).chats[index];
                            if (HomeCubit.get(context).userModel!.uId ==
                                message.senderId)
                              return buildMyMessage(message);
                            return buildMessage(message);
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 15,
                            );
                          },
                          itemCount: HomeCubit.get(context).chats.length,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (HomeCubit.get(context).chatImage != null)
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
                                        image: FileImage(HomeCubit.get(context)
                                            .chatImage!)))),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: CircleAvatar(
                                  radius: 20,
                                  child: IconButton(
                                      onPressed: () {
                                        HomeCubit.get(context)
                                            .removeChatImage();
                                      },
                                      icon: Icon(Icons.close)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromARGB(255, 185, 176, 176),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                cursorColor: Colors.green,
                                textDirection: TextDirection.rtl,
                                controller: messageCotroller,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'أكتب هنا ...',
                                    hintTextDirection: TextDirection.rtl),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  HomeCubit.get(context).pickChatImage();
                                },
                                icon: Icon(
                                  Icons.camera_alt_outlined,
                                  color: mainColor,
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            MaterialButton(
                                color: mainColor,
                                minWidth: 40,
                                height: 55,
                                onPressed: () {
                                  {
                                    if (HomeCubit.get(context).chatImage ==
                                        null) {
                                      if (messageCotroller.text != '')
                                        HomeCubit.get(context).sendMessage(
                                          receiverId: uId,
                                          dateTime: DateTime.now().toString(),
                                          text: messageCotroller.text,
                                          token: fToken,
                                        );
                                      messageCotroller.clear();
                                    } else {
                                      HomeCubit.get(context).sendChatImage(
                                        text: messageCotroller.text,
                                        receiverId: uId,
                                        dateTime: DateTime.now().toString(),
                                        fToken: fToken,
                                      );

                                      messageCotroller.clear();
                                    }
                                    HomeCubit.get(context).removeChatImage();
                                  }
                                },
                                child: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
          });
    });
  }
}

Widget buildMessage(ChatModel model) => Column(
      children: [
        if (model.text != '')
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: Colors.grey[300]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(model.text),
                )),
          ),
        if (model.image != '')
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    image: DecorationImage(
                      image: NetworkImage('${model.image}'),
                      fit: BoxFit.cover,
                    )),
              ),
            ),
          ),
      ],
    );

Widget buildMyMessage(ChatModel model) => Column(
      children: [
        if (model.text != '')
          Align(
            alignment: Alignment.topRight,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    color: Color.fromARGB(255, 179, 229, 192)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(model.text),
                )),
          ),
        if (model.image != '')
          Align(
            alignment: Alignment.topRight,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      image: DecorationImage(
                        image: NetworkImage('${model.image}'),
                        fit: BoxFit.cover,
                      )),
                )),
          )
      ],
    );
