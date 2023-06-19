import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/model/inventory.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/use_case/use_case.dart';

class GetInventoryUseCase implements UseCase<Inventory, GetInventoryParams> {
  final ChopRepository _repo;

  const GetInventoryUseCase(this._repo);

  @override
  Future<Either<Failure, Inventory>> call(GetInventoryParams params) =>
      _repo.getInventory(params);
}

class GetInventoryParams {
  final int inventoryId;

  const GetInventoryParams({required this.inventoryId});
}
