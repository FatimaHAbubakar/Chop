import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/model/review.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/use_case/use_case.dart';

class CreateReviewUseCase implements UseCase<Review, CreateReviewParams> {
  final ChopRepository _repo;

  const CreateReviewUseCase(this._repo);

  @override
  Future<Either<Failure, Review>> call(CreateReviewParams params) =>
      _repo.createReview(params);
}

class CreateReviewParams {
  final int star;
  final String? description;
  final int vendorId;
  final int fiiId;

  const CreateReviewParams({
    required this.star,
    required this.description,
    required this.vendorId,
    required this.fiiId,
  });
}
