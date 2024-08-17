import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widget/chat_bublle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  TextEditingController controller = TextEditingController();

  final ScrollController _controller = ScrollController();

  File? imgFile;

  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments as String;
    return StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Message> messagesList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              messagesList.add(Message.fromJson(snapshot.data!.docs[i].data()));
            }
            var textField = TextField(
              controller: controller,
              onSubmitted: (data) {
                if (data.isNotEmpty) {
                  messages.add({
                    'messages': data,
                    'createdAt': DateTime.now(),
                    'id': email,
                  });
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
                      // upload image to firebase storage

                      var nameImage = basename(imgFile!.path);
                      var random = Random().nextInt(100000);
                      nameImage = '$random$nameImage';
                      final imageRef = FirebaseStorage.instance.ref(nameImage);

                      await imageRef.putFile(imgFile!);

                      final downloadUrl = await imageRef.getDownloadURL();

                      // ***********************************//
                      messages.add({
                        'messages': downloadUrl,
                        'createdAt': DateTime.now(),
                        'id': email,
                      });

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
                      messages.add({
                        'messages': data,
                        'createdAt': DateTime.now(),
                        'id': email,
                      });
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
            );
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
                      child: ListView.builder(
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
                      ),
                    ),
                    textField,
                  ],
                ),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              ),
            );
          }
        });
  }

  void _scrollDown() {
    _controller.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOutCirc,
    );
  }
}
