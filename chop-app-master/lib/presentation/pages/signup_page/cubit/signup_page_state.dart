part of 'signup_page_cubit.dart';

abstract class SignupPageState extends Equatable {
  const SignupPageState();

  @override
  List<Object> get props => [];
}

class SignupPageInitial extends SignupPageState {}

class SignupPageError extends SignupPageState {
  final String errorMessage;

  const SignupPageError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class SignupPageLoading extends SignupPageState {}

class SignupSuccess extends SignupPageState {
  final User user;

  const SignupSuccess(this.user);

  @override
  List<Object> get props => [user];
}
