import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/model/review.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/use_case/use_case.dart';

class DeleteReviewUseCase implements UseCase<Review, DeleteReviewParams> {
  final ChopRepository _repo;

  const DeleteReviewUseCase(this._repo);

  @override
  Future<Either<Failure, Review>> call(DeleteReviewParams params) =>
      _repo.deleteReview(params);
}

class DeleteReviewParams {
  final int reviewId;

  const DeleteReviewParams({required this.reviewId});
}
