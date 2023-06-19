import 'package:bloc/bloc.dart';
import 'package:chop/domain/model/inventory.dart';
import 'package:chop/domain/use_cases/get_inventories_use_case.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/failure/failure.dart';

part 'vendor_detail_page_state.dart';

class VendorDetailPageCubit extends Cubit<VendorDetailPageState> {
  final GetInventoriesUseCase useCase;

  VendorDetailPageCubit(this.useCase) : super(VendorDetailPageLoading());

  Future<void> getInventories(int vendorId) async {
    final result = await useCase.call(GetInventoriesParams(vendorId: vendorId));

    result.fold((l) {
      if (l is UnauthenticatedFailure) {
        emit(VendorDetailPageSignOut());
      } else {
        emit(VendorDetailPageError(l.errorMessage));
      }
    }, (r) => emit(VendorDetailPageInitial(r)));
  }
}
