part of 'vendor_rescue_page_cubit.dart';

abstract class VendorRescuePageState extends Equatable {
  const VendorRescuePageState();

  @override
  List<Object> get props => [];
}

class VendorRescuePageError extends VendorRescuePageState {
  final String errorMessage;

  const VendorRescuePageError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class VendorRescuePageSignOut extends VendorRescuePageState {}

class VendorRescuePageLoading extends VendorRescuePageState {}

class VendorRescuePageSuccess extends VendorRescuePageState {}

class VendorRescuePageInitial extends VendorRescuePageState {
  final List<Rescue> rescues;
  final List<RescueInventory> rescueInventories;

  const VendorRescuePageInitial(this.rescues, this.rescueInventories);

  @override
  List<Object> get props => [rescues, rescueInventories];
}
