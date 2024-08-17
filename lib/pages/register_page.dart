// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/pages/cubits/register_cubit/register_cubit.dart';
import 'package:chat_app/pages/sign_in_page.dart';
import 'package:chat_app/widget/custom_button.dart';
import 'package:chat_app/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore: must_be_immutable
class RegisterPage extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static String id = 'RegisterPage';

  bool isLoading = false;
  String? email;
  String? password;

  RegisterPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          isLoading = false;
          showSnackBar(context, 'Account created successfully.');
          Navigator.pushNamed(context, SignInPage.id);
        } else if (state is RegisterFailure) {
          isLoading = false;
          showSnackBar(context,state.errMessage );
        }else if (state is RegisterLoading) {
          isLoading = true;
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
                child: ListView(children: [
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
                        'Register',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
                      buttonText: 'REGISTER',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          BlocProvider.of<RegisterCubit>(context).regiserUser(
                                email: email!, password: password!);             
                          
                        } else {}
                      }),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'already have an account?',
                        style: TextStyle(
                          fontSize: 20,
                          color: kUser1Color,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: kUser2Color,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
