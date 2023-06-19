part of 'checkout_page_cubit.dart';

abstract class CheckoutPageState extends Equatable {
  const CheckoutPageState();

  @override
  List<Object> get props => [];
}

class CheckoutPageInitial extends CheckoutPageState {}

class CheckoutPageError extends CheckoutPageState {
  final String errorMessage;

  const CheckoutPageError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class CheckoutPageLoading extends CheckoutPageState {}

class CheckoutPageSignOut extends CheckoutPageState {}

class CheckoutSuccess extends CheckoutPageState {
  final Rescue rescue;

  const CheckoutSuccess(this.rescue);

  @override
  List<Object> get props => [rescue];
}
