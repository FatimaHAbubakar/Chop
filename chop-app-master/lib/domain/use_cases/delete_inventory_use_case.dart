import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/model/inventory.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/use_case/use_case.dart';

class DeleteInventoryUseCase
    implements UseCase<Inventory, DeleteInventoryParams> {
  final ChopRepository _repo;

  const DeleteInventoryUseCase(this._repo);

  @override
  Future<Either<Failure, Inventory>> call(DeleteInventoryParams params) =>
      _repo.deleteInventory(params);
}

class DeleteInventoryParams {
  final int inventoryId;

  const DeleteInventoryParams({required this.inventoryId});
}
