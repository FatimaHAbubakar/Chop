part of 'vendor_add_item_page_cubit.dart';

abstract class VendorAddItemPageState extends Equatable {
  const VendorAddItemPageState();

  @override
  List<Object> get props => [];
}

class VendorAddItemPageInitial extends VendorAddItemPageState {
  final User vendor;

  const VendorAddItemPageInitial(this.vendor);

  @override
  List<Object> get props => [vendor];
}

class VendorAddItemPageError extends VendorAddItemPageState {
  final String errorMessage;

  const VendorAddItemPageError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class VendorAddItemPageLoading extends VendorAddItemPageState {}

class VendorAddItemPageSignOut extends VendorAddItemPageState {}

class VendorAddItemSuccess extends VendorAddItemPageState {
  final User user;

  const VendorAddItemSuccess(this.user);

  @override
  List<Object> get props => [user];
}
