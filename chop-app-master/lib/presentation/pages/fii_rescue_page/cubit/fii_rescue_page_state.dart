part of 'fii_rescue_page_cubit.dart';

abstract class FIIRescuePageState extends Equatable {
  const FIIRescuePageState();

  @override
  List<Object> get props => [];
}

class FIIRescuePageError extends FIIRescuePageState {
  final String errorMessage;

  const FIIRescuePageError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FIIRescuePageSignOut extends FIIRescuePageState {}

class FIIRescuePageLoading extends FIIRescuePageState {}

class FIIRescuePageInitial extends FIIRescuePageState {
  final List<Rescue> rescues;
  final List<RescueInventory> rescueInventories;

  const FIIRescuePageInitial(this.rescues, this.rescueInventories);

  @override
  List<Object> get props => [rescues, rescueInventories];
}
