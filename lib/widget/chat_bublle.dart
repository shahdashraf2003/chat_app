import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class ChatBubble extends StatelessWidget {
  bool isLoading = true;
  final Message text;

  ChatBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            color: kUser1Color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            )),
        child: isImagePath(text.message) == false
            ? Text(text.message,
                style: const TextStyle(color: Colors.white, fontSize: 20))
            : ShowImage(text: text),
        // Image.network(text.message, fit: BoxFit.cover,
        // frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        //   return child;

        // },
        // loadingBuilder: (context,child, loadingProgress) {
        //   if(loadingProgress == null) {
        //     return child;
        //   } else {
        //     return const Center(child: CircularProgressIndicator());

        //   }
        // },),
      ),
    );
  }
}

class ChatBubbleForFriend extends StatelessWidget {
  const ChatBubbleForFriend({super.key, required this.text});
  final Message text;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            color: kUser2Color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            )),
        child: isImagePath(text.message) == false
            ? Text(
                text.message,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              )
            : ShowImage(text: text),
        // child: _isImagePath(text.message) == false
        //     ? Text(text.message,
        //         style: const TextStyle(color: Colors.white, fontSize: 20))
        //     : Image.network(text.message, fit: BoxFit.cover),
      ),
    );
  }
}

bool isImagePath(String path) {
  if (path.startsWith('https://')) {
    return true;
  } else {
    return false;
  }
}

class ShowImage extends StatelessWidget {
  const ShowImage.named({super.key, required this.text});

  const ShowImage({
    super.key,
    required this.text,
  });

  final Message text;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: text.message,
      fit: BoxFit.fill,
      placeholder: (context, url) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        );
      },
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
