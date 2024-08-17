import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
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
