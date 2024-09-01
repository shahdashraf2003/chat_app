// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/cubits/auth_cubit/auth_cubit.dart';
import 'package:chat_app/pages/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/widget/custom_button.dart';
import 'package:chat_app/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore: must_be_immutable
class SignInPage extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static String id = 'SignInPage';

  String? email;
  String? password;

  bool isLoading = false;

  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          isLoading = false;
          BlocProvider.of<ChatCubit>(context).getMessage();
          showSnackBar(context, 'Login successfully.');
          Navigator.pushNamed(context, ChatPage.id, arguments: email);
        } else if (state is LoginFailure) {
          isLoading = false;
          showSnackBar(context, state.errMessage);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            backgroundColor: kPrimaryColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 100),
                    Image.asset(
                      kImage,
                      width: 100,
                      height: 120,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Messagerie',
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'pacifico',
                            color: kUser1Color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    const Row(
                      children: [
                        Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xffe5e5e5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    CustomTextFormField(
                      onChanged: (value) {
                        email = value;
                      },
                      hintText: 'Email',
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      onChanged: (value) {
                        password = value;
                      },
                      hintText: 'Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    Button(
                        buttonText: 'LOGIN',
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<AuthCubit>(context)
                                .userLogin(email: email!, password: password!);
                          } else {}
                        }),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'don\'t have an account?',
                          style: TextStyle(
                            fontSize: 20,
                            color: kUser1Color,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, RegisterPage.id);
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: kUser2Color,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
