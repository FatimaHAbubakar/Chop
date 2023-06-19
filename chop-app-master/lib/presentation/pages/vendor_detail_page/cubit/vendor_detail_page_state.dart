part of 'vendor_detail_page_cubit.dart';

abstract class VendorDetailPageState extends Equatable {
  const VendorDetailPageState();

  @override
  List<Object> get props => [];
}

class VendorDetailPageError extends VendorDetailPageState {
  final String errorMessage;

  const VendorDetailPageError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class VendorDetailPageSignOut extends VendorDetailPageState {}

class VendorDetailPageLoading extends VendorDetailPageState {}

class VendorDetailPageInitial extends VendorDetailPageState {
  final List<Inventory> foods;

  const VendorDetailPageInitial(this.foods);

  @override
  List<Object> get props => [foods];
}
