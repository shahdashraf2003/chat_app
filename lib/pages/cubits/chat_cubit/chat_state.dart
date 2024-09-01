part of 'chat_cubit.dart';

abstract class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatSuccess extends ChatState {
  List<Message> messagesList;
  ChatSuccess({required this.messagesList});
}

