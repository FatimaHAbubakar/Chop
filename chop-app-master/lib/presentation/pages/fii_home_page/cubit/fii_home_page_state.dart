part of 'fii_home_page_cubit.dart';

abstract class FIIHomePageState extends Equatable {
  const FIIHomePageState();

  @override
  List<Object> get props => [];
}

class FIIHomePageError extends FIIHomePageState {
  final String errorMessage;

  const FIIHomePageError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FIIHomePageSignOut extends FIIHomePageState {}

class FIIHomePageLoading extends FIIHomePageState {}

class FIIHomePageInitial extends FIIHomePageState {
  final List<User> vendors;
  final List<Review> reviews;

  const FIIHomePageInitial(this.vendors, this.reviews);

  @override
  List<Object> get props => [vendors, reviews];
}
