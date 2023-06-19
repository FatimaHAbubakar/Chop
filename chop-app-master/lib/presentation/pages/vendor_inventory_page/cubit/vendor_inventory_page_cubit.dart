import 'package:bloc/bloc.dart';
import 'package:chop/core/failure/failure.dart';
import 'package:chop/core/use_case/use_case.dart';
import 'package:chop/domain/model/inventory.dart';
import 'package:chop/domain/model/user.dart';
import 'package:chop/domain/use_cases/delete_inventory_use_case.dart';
import 'package:chop/domain/use_cases/get_inventories_use_case.dart';
import 'package:chop/domain/use_cases/get_user_use_case.dart';
import 'package:chop/domain/use_cases/update_inventory_use_case.dart';
import 'package:equatable/equatable.dart';

part 'vendor_inventory_page_state.dart';

class VendorInventoryPageCubit extends Cubit<VendorInventoryPageState> {
  final GetInventoriesUseCase getInventoriessUseCase;
  final GetUserUseCase getUserUseCase;
  final UpdateInventoryUseCase updateInventoryUseCase;
  final DeleteInventoryUseCase deleteInventoryUseCase;

  VendorInventoryPageCubit(this.getInventoriessUseCase, this.getUserUseCase,
      this.updateInventoryUseCase, this.deleteInventoryUseCase)
      : super(VendorInventoryPageLoading());

  Future<User?> getUser() async {
    final result = await getUserUseCase.call(NoParams());

    User? user;
    result.fold((l) => emit(VendorInventoryPageSignOut()), (r) => user = r);
    return user;
  }

  Future<void> getInventories() async {
    emit(VendorInventoryPageLoading());

    User? user = await getUser();
    if (user == null) return;

    final result = await getInventoriessUseCase
        .call(GetInventoriesParams(vendorId: user.id));

    result.fold((l) {
      if (l is UnauthenticatedFailure) {
        emit(VendorInventoryPageSignOut());
      } else {
        emit(VendorInventoryPageError(l.errorMessage));
      }
    }, (r) {
      r.removeWhere((food) => food.deleted);
      emit(VendorInventoryPageInitial(r));
    });
  }

  Future<void> updateInventory(
      inventoryId, name, category, stock, price, discount) async {
    User? user = await getUser();
    if (user == null) return;

    final result = await updateInventoryUseCase.call(UpdateInventoryParams(
        inventoryId: inventoryId,
        name: name,
        category: category,
        stock: stock,
        price: price,
        discount: discount,
        vendorId: user.id));

    result.fold((l) {
      if (l is UnauthenticatedFailure) {
        emit(VendorInventoryPageSignOut());
      } else {
        emit(VendorInventoryPageError(l.errorMessage));
      }
    }, (r) => getInventories());
  }

  Future<void> deleteInventory(DeleteInventoryParams params) async {
    User? user = await getUser();
    if (user == null) return;

    final result = await deleteInventoryUseCase.call(params);

    result.fold((l) {
      if (l is UnauthenticatedFailure) {
        emit(VendorInventoryPageSignOut());
      } else {
        emit(VendorInventoryPageError(l.errorMessage));
      }
    }, (r) => getInventories());
  }
}
