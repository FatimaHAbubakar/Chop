import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/model/inventory.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/use_case/use_case.dart';

class UpdateInventoryUseCase
    implements UseCase<Inventory, UpdateInventoryParams> {
  final ChopRepository _repo;

  const UpdateInventoryUseCase(this._repo);

  @override
  Future<Either<Failure, Inventory>> call(UpdateInventoryParams params) =>
      _repo.updateInventory(params);
}

class UpdateInventoryParams {
  final int inventoryId;
  final String name;
  final String category;
  final int stock;
  final double price;
  final double discount;
  final int vendorId;

  const UpdateInventoryParams({
    required this.inventoryId,
    required this.name,
    required this.category,
    required this.stock,
    required this.price,
    required this.discount,
    required this.vendorId,
  });
}
