import 'package:chop/core/failure/failure.dart';
import 'package:chop/core/use_case/use_case.dart';
import 'package:chop/domain/model/inventory.dart';
import 'package:chop/domain/model/rescue.dart';
import 'package:chop/domain/model/rescue_inventory.dart';
import 'package:chop/domain/model/review.dart';
import 'package:chop/domain/model/user.dart';
import 'package:chop/domain/use_cases/checkout_use_case.dart';
import 'package:chop/domain/use_cases/create_inventory_use_case.dart';
import 'package:chop/domain/use_cases/create_rescue_use_case.dart';
import 'package:chop/domain/use_cases/create_review_use_case.dart';
import 'package:chop/domain/use_cases/delete_inventory_use_case.dart';
import 'package:chop/domain/use_cases/delete_rescue_use_case.dart';
import 'package:chop/domain/use_cases/delete_review_use_case.dart';
import 'package:chop/domain/use_cases/get_inventory_use_case.dart';
import 'package:chop/domain/use_cases/get_rescue_inventories.dart';
import 'package:chop/domain/use_cases/get_rescue_use_case.dart';
import 'package:chop/domain/use_cases/get_rescues_use_case.dart';
import 'package:chop/domain/use_cases/get_review_use_case.dart';
import 'package:chop/domain/use_cases/login_use_case.dart';
import 'package:chop/domain/use_cases/register_use_case.dart';
import 'package:chop/domain/use_cases/update_inventory_use_case.dart';
import 'package:chop/domain/use_cases/update_rescue_use_case.dart';
import 'package:chop/domain/use_cases/update_review_use_case.dart';
import 'package:chop/domain/use_cases/verify_code_use_case.dart';
import 'package:dartz/dartz.dart';

import '../use_cases/get_inventories_use_case.dart';

abstract class ChopRepository {
  Future<Either<Failure, User>> login(LoginParams params);
  Future<Either<Failure, User>> register(RegisterParams params);
  Future<Either<Failure, Inventory>> createInventory(
      CreateInventoryParams params);
  Future<Either<Failure, Rescue>> createRescue(CreateRescueParams params);
  Future<Either<Failure, Review>> createReview(CreateReviewParams params);
  Future<Either<Failure, Inventory>> deleteInventory(
      DeleteInventoryParams params);
  Future<Either<Failure, Rescue>> deleteRescue(DeleteRescueParams params);
  Future<Either<Failure, Review>> deleteReview(DeleteReviewParams params);
  Future<Either<Failure, Inventory>> getInventory(GetInventoryParams params);
  Future<Either<Failure, Rescue>> getRescue(GetRescueParams params);
  Future<Either<Failure, Review>> getReview(GetReviewParams params);
  Future<Either<Failure, List<Inventory>>> getInventories(
      GetInventoriesParams params);
  Future<Either<Failure, List<Rescue>>> getRescues(GetRescuesParams params);
  Future<Either<Failure, List<Review>>> getReviews(NoParams params);
  Future<Either<Failure, Inventory>> updateInventory(
      UpdateInventoryParams params);
  Future<Either<Failure, Rescue>> updateRescue(UpdateRescueParams params);
  Future<Either<Failure, Review>> updateReview(UpdateReviewParams params);
  Future<Either<Failure, User>> getUser(NoParams params);
  Future<Either<Failure, List<User>>> getVendors(NoParams params);
  Future<Either<Failure, List<RescueInventory>>> getRescueInventories(
      GetRescueInventoriesParams params);
  Future<Either<Failure, Rescue>> checkOut(CheckOutParams params);
  Future<Either<Failure, Rescue>> verifyCode(VerifyCodeParams params);
  Future<Either<Failure, void>> logOut(NoParams params);
}
