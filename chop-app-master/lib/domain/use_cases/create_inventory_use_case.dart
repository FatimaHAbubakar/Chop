import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/model/inventory.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/use_case/use_case.dart';

class CreateInventoryUseCase
    implements UseCase<Inventory, CreateInventoryParams> {
  final ChopRepository _repo;

  const CreateInventoryUseCase(this._repo);

  @override
  Future<Either<Failure, Inventory>> call(CreateInventoryParams params) =>
      _repo.createInventory(params);
}

class CreateInventoryParams {
  final String name;
  final String category;
  final int stock;
  final double price;
  final double discount;
  final int vendorId;

  const CreateInventoryParams(
      {required this.name,
      required this.category,
      required this.stock,
      required this.price,
      required this.discount,
      required this.vendorId});
}
