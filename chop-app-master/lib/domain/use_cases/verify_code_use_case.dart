import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/use_case/use_case.dart';

class VerifyCodeUseCase implements UseCase<void, VerifyCodeParams> {
  final ChopRepository _repo;

  const VerifyCodeUseCase(this._repo);

  @override
  Future<Either<Failure, void>> call(VerifyCodeParams params) =>
      _repo.verifyCode(params);
}

class VerifyCodeParams {
  final int rescueId;
  final String code;

  const VerifyCodeParams({
    required this.rescueId,
    required this.code,
  });
}
