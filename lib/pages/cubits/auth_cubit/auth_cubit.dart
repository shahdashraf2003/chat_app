import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  Future<void> userLogin(

      {required String email, required String password}) async {
    emit(LoginLoading());
    try {
      // ignore: unused_local_variable
      final credentialUser =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailure(errMessage: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure(errMessage: 'Wrong password '));
      } else {
        emit(LoginFailure(errMessage: 'Check your email and password'));
      }
    } catch (e) {
      emit(LoginFailure(errMessage: 'something went wrong'));
    }
  }
Future<void> regiserUser({required String email, required String password}) async {
    emit(RegisterLoading());
    try {
      // ignore: unused_local_variable
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterFailure(errMessage: 'The password  is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailure(errMessage: 'The account already exists.'));
      }
    } catch (e) {
      emit(RegisterFailure(errMessage: 'something went wrong'));
    }
  }
}
