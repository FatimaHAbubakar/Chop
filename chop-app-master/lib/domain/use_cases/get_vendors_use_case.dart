import 'package:chop/domain/model/user.dart';
import 'package:dartz/dartz.dart';

import '../../core/failure/failure.dart';
import '../../core/use_case/use_case.dart';
import '../repositories/chop_repository.dart';

class GetVendorsUseCase implements UseCase<List<User>, NoParams> {
  final ChopRepository _repo;

  const GetVendorsUseCase(this._repo);

  @override
  Future<Either<Failure, List<User>>> call(NoParams params) =>
      _repo.getVendors(params);
}
