import 'dart:io';
import 'dart:math';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/pages/cubits/chat_cubit/chat_cubit.dart';

import 'package:chat_app/constants.dart';
import 'package:chat_app/widget/chat_bublle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

// ignore: must_be_immutable
class ChatPage extends StatelessWidget {
  ChatPage({
    super.key,
  });
  static String id = 'ChatPage';
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollections);
  List<Message> messagesList = [];
  TextEditingController controller = TextEditingController();

  final ScrollController _controller = ScrollController();

  File? imgFile;

  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments as String;

    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                kImage,
                width: 50,
                height: 50,
              ),
              const Text(
                'Chat',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'pacifico',
                    color: Color.fromARGB(255, 253, 252, 253)),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  var messagesList =
                      BlocProvider.of<ChatCubit>(context).messagesList;

                  return ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == email
                          ? ChatBubble(
                              text: messagesList[index],
                            )
                          : ChatBubbleForFriend(text: messagesList[index]);
                    },
                  );
                },
              ),
            ),
            TextField(
              controller: controller,
              onSubmitted: (data) {
                if (data.isNotEmpty) {
                  BlocProvider.of<ChatCubit>(context).sendMessage(
                    data: data,
                    email: email,
                  );
                  controller.clear();
                  _scrollDown();
                }
              },
              decoration: InputDecoration(
                hintText: 'Send Message',
                prefixIcon: IconButton(
                  onPressed: () async {
                    final XFile? imgPicked = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      maxHeight: 300,
                      maxWidth: 300,
                    );

                    if (imgPicked != null) {
                      imgFile = File(imgPicked.path);

                      var nameImage = basename(imgFile!.path);
                      var random = Random().nextInt(100000);
                      nameImage = '$random$nameImage';
                      final imageRef = FirebaseStorage.instance.ref(nameImage);

                      await imageRef.putFile(imgFile!);

                      final downloadUrl = await imageRef.getDownloadURL();

                      // ignore: use_build_context_synchronously
                      BlocProvider.of<ChatCubit>(context).sendMessage(
                        email: email,
                        data: downloadUrl,
                      );
                      controller.clear();
                      _scrollDown();
                    }
                  },
                  icon: const Icon(
                    Icons.image,
                    color: kPrimaryColor,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    var data = controller.text;
                    if (data.isNotEmpty) {
                      BlocProvider.of<ChatCubit>(context).sendMessage(
                        data: data,
                        email: email,
                      );
                      controller.clear();
                      _scrollDown();
                    }
                  },
                  icon: const Icon(
                    Icons.send,
                  ),
                ),
                suffixIconColor: kPrimaryColor,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollDown() {
    _controller.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOutCirc,
    );
  }
}
