part of 'vendor_inventory_page_cubit.dart';

abstract class VendorInventoryPageState extends Equatable {
  const VendorInventoryPageState();

  @override
  List<Object> get props => [];
}

class VendorInventoryPageError extends VendorInventoryPageState {
  final String errorMessage;

  const VendorInventoryPageError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class VendorInventoryPageSignOut extends VendorInventoryPageState {}

class VendorInventoryPageLoading extends VendorInventoryPageState {}

class VendorInventoryPageInitial extends VendorInventoryPageState {
  final List<Inventory> inventories;

  const VendorInventoryPageInitial(this.inventories);

  @override
  List<Object> get props => [inventories];
}
