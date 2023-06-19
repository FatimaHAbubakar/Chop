import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/model/inventory.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/use_case/use_case.dart';

class GetInventoriesUseCase
    implements UseCase<List<Inventory>, GetInventoriesParams> {
  final ChopRepository _repo;

  const GetInventoriesUseCase(this._repo);

  @override
  Future<Either<Failure, List<Inventory>>> call(GetInventoriesParams params) =>
      _repo.getInventories(params);
}

class GetInventoriesParams {
  final int? vendorId;

  const GetInventoriesParams({this.vendorId});
}
