part of 'auth_cubit.dart';


 class AuthState {}

final class AuthInitial extends AuthState {}

final class LoginLoading extends AuthState {}

final class LoginSuccess extends AuthState {}

final class  LoginFailure extends AuthState {
  String errMessage;
  LoginFailure({required this.errMessage});
}

class RegisterLoading extends AuthState {}
class RegisterSuccess extends AuthState {}
class RegisterFailure extends AuthState {
  final String errMessage;
  RegisterFailure({required this.errMessage});
}
