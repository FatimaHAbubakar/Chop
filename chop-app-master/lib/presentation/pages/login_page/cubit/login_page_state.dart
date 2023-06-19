part of 'login_page_cubit.dart';

abstract class LoginPageState extends Equatable {
  const LoginPageState();

  @override
  List<Object> get props => [];
}

class LoginPageInitial extends LoginPageState {}

class LoginPageError extends LoginPageState {
  final String errorMessage;

  const LoginPageError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class LoginPageLoading extends LoginPageState {}

class LoginSuccess extends LoginPageState {
  final User user;

  const LoginSuccess(this.user);

  @override
  List<Object> get props => [user];
}
