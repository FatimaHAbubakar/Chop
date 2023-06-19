import 'package:bloc/bloc.dart';
import 'package:chop/core/use_case/use_case.dart';
import 'package:chop/domain/use_cases/create_inventory_use_case.dart';
import 'package:chop/domain/use_cases/get_user_use_case.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/failure/failure.dart';
import '../../../../domain/model/user.dart';

part 'vendor_add_item_page_state.dart';

class VendorAddItemPageCubit extends Cubit<VendorAddItemPageState> {
  final CreateInventoryUseCase createInventoryUseCase;
  final GetUserUseCase getUserUseCase;

  VendorAddItemPageCubit(this.createInventoryUseCase, this.getUserUseCase)
      : super(VendorAddItemPageLoading());

  Future<void> addItem(CreateInventoryParams params) async {
    emit(VendorAddItemPageLoading());

    final result = await createInventoryUseCase.call(params);

    result.fold((l) {
      if (l is UnauthenticatedFailure) {
        emit(VendorAddItemPageSignOut());
      } else {
        emit(VendorAddItemPageError(l.errorMessage));
      }
    }, (r) => getUser(success: true));
  }

  Future<void> getUser({bool? success}) async {
    final result = await getUserUseCase.call(NoParams());

    result.fold((l) {
      emit(VendorAddItemPageSignOut());
    },
        (r) => emit(success == null
            ? VendorAddItemPageInitial(r)
            : VendorAddItemSuccess(r)));
  }
}
