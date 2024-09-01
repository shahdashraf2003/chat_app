import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/pages/cubits/login_cubit/login_cubit.dart';
import 'package:chat_app/pages/cubits/register_cubit/register_cubit.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/pages/sign_in_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChatAPP());
}

class ChatAPP extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  ChatAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => ChatCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          SignInPage.id: (context) => SignInPage(),
          RegisterPage.id: (context) => RegisterPage(),
          ChatPage.id: (context) => ChatPage(),
        },
        initialRoute: SignInPage.id,
      ),
    );
  }
}
