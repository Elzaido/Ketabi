// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables

import 'package:book_swapping/shared/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../shared/Cubit/home/home_cubit.dart';
import '../../shared/component.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loading();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching user data'),
            );
          } else {
            final userData = snapshot.data?.data() as Map<String, dynamic>?;

            // Get the list of user IDs from the user data
            final List<String> chatlist =
                List<String>.from(userData?['chatlist'] ?? []);
            bool noSeparate = false;

            return chatlist.isNotEmpty
                ? SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: ((context, index) {
                              final user = HomeCubit.get(context).users[index];
                              // Check if the user's ID is in the chatlist of the current user.
                              final bool isUserInChatList =
                                  chatlist.contains(user.uId);
                              // If the user's ID is in the chatlist, display the chat item.
                              if (isUserInChatList) {
                                return chatItem(context,
                                    user); // Return the chat item widget.
                              } else {
                                noSeparate = true;
                                return Container(
                                  height: 0,
                                );
                                // Return an empty container if the condition is false.
                              }
                            }),
                            separatorBuilder: ((context, index) => noSeparate
                                ? Container(
                                    height: 0,
                                  )
                                : separator()),
                            itemCount: HomeCubit.get(context).users.length),
                        SizedBox(
                          height: 25,
                        )
                      ],
                    ))
                : Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '!',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'لا يوجد لديك دردشات حتى الآن',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        SizedBox(
                            height: 50,
                            width: 50,
                            child:
                                Image(image: AssetImage('assets/NoChat.png')))
                      ],
                    ),
                  );
          }
        });
  }
}
