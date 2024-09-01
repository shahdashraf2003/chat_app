import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollections);
  List<Message> messagesList = [];
  void sendMessage({required String data, required String email}) {
    try {
      messages.add({
        'messages': data,
        'createdAt': DateTime.now(),
        'id': email,
      });
    // ignore: empty_catches
    } catch (e) {

    }
  }

  void getMessage() {
    messages.orderBy('createdAt', descending: true).snapshots().listen((event) {
      messagesList.clear();

      for (var doc in event.docs) {
        messagesList.add(Message.fromJson(doc));
      }
      emit(ChatSuccess(messagesList: messagesList));
    });
  }
}
