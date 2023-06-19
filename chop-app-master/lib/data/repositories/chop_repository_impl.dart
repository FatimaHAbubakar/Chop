import 'dart:math';

import 'package:chop/core/failure/error.dart';
import 'package:chop/data/data_sources/chop_local_data_source.dart';
import 'package:chop/data/data_sources/chop_remote_data_source.dart';
import 'package:chop/domain/model/rescue_inventory.dart';
import 'package:chop/domain/model/user.dart';
import 'package:chop/domain/model/review.dart';
import 'package:chop/domain/model/rescue.dart';
import 'package:chop/domain/model/inventory.dart';
import 'package:chop/core/use_case/use_case.dart';
import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:chop/domain/use_cases/checkout_use_case.dart';
import 'package:chop/domain/use_cases/get_inventories_use_case.dart';
import 'package:chop/domain/use_cases/get_rescue_inventories.dart';
import 'package:chop/domain/use_cases/verify_code_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:chop/domain/use_cases/update_review_use_case.dart';
import 'package:chop/domain/use_cases/update_rescue_use_case.dart';
import 'package:chop/domain/use_cases/update_inventory_use_case.dart';
import 'package:chop/domain/use_cases/register_use_case.dart';
import 'package:chop/domain/use_cases/login_use_case.dart';
import 'package:chop/domain/use_cases/get_review_use_case.dart';
import 'package:chop/domain/use_cases/get_rescue_use_case.dart';
import 'package:chop/domain/use_cases/get_inventory_use_case.dart';
import 'package:chop/domain/use_cases/delete_review_use_case.dart';
import 'package:chop/domain/use_cases/delete_rescue_use_case.dart';
import 'package:chop/domain/use_cases/delete_inventory_use_case.dart';
import 'package:chop/domain/use_cases/create_review_use_case.dart';
import 'package:chop/domain/use_cases/create_rescue_use_case.dart';
import 'package:chop/domain/use_cases/create_inventory_use_case.dart';

import '../../domain/use_cases/get_rescues_use_case.dart';

class ChopRepositoryImpl extends ChopRepository {
  final ChopRemoteDataSource remote;
  final ChopLocalDataSource local;

  ChopRepositoryImpl(this.remote, this.local);

  Future<User?> getFiiById(String token, fiiId) async {
    final fiis = await remote.getFiis(token);
    User? fii;
    for (var fiiJson in fiis) {
      if (fiiJson['id'] == fiiId) {
        fii = User.fromJson(fiiJson);
        break;
      }
    }
    return fii;
  }

  Future<User?> getVendorById(String token, vendorId) async {
    final vendors = await remote.getVendors(token);
    User? vendor;
    for (var vendorJson in vendors) {
      if (vendorJson['id'] == vendorId) {
        vendor = User.fromJson(vendorJson);
        break;
      }
    }
    return vendor;
  }

  @override
  Future<Either<Failure, User>> login(LoginParams params) async {
    try {
      final json = await remote.login(params);
      local.setToken(json['access_token']);
      User user = User.fromJson(json['user']);
      local.setUser(user);
      return Right(user);
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on CacheException {
      return Left(CacheFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, User>> register(RegisterParams params) async {
    try {
      final json = await remote.register(params);
      local.setToken(json['token']);
      User user = User.fromJson(json['user']);
      local.setUser(user);
      return Right(user);
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on CacheException {
      return Left(CacheFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, Inventory>> createInventory(
      CreateInventoryParams params) async {
    try {
      String? token = local.getToken();
      if (token == null) throw UnauthenticatedException();
      final json = await remote.createInventory(params, token);
      return Right(Inventory.fromJson(json));
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, Rescue>> createRescue(
      CreateRescueParams params) async {
    try {
      String? token = local.getToken();
      if (token == null) throw UnauthenticatedException();
      User? user = local.getUser();
      if (user == null) throw UnauthenticatedException();

      final rescueJson = await remote.createRescue(params, token);
      final rescueInventoriesJson = await remote.getRescueInventoriesForRescue(
          token,
          GetRescueInventoriesParams(user.role, user.id),
          rescueJson['id']);

      return Right(
          Rescue.fromJson(rescueJson, calculateTotal(rescueInventoriesJson)));
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, Review>> createReview(
      CreateReviewParams params) async {
    try {
      String? token = local.getToken();
      if (token == null) throw UnauthenticatedException();
      final json = await remote.createReview(params, token);
      return Right(Review.fromJson(json));
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, Inventory>> deleteInventory(
      DeleteInventoryParams params) async {
    try {
      String? token = local.getToken();
      if (token == null) throw UnauthenticatedException();
      final json = await remote.deleteInventory(params.inventoryId, token);
      return Right(Inventory.fromJson(json));
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, Rescue>> deleteRescue(
      DeleteRescueParams params) async {
    try {
      String? token = local.getToken();
      if (token == null) throw UnauthenticatedException();
      User? user = local.getUser();
      if (user == null) throw UnauthenticatedException();

      final rescueJson = await remote.deleteRescue(params.rescueId, token);
      final rescueInventoriesJson = await remote.getRescueInventoriesForRescue(
          token,
          GetRescueInventoriesParams(user.role, user.id),
          rescueJson['id']);
      return Right(
          Rescue.fromJson(rescueJson, calculateTotal(rescueInventoriesJson)));
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, Review>> deleteReview(
      DeleteReviewParams params) async {
    try {
      String? token = local.getToken();
      if (token == null) throw UnauthenticatedException();
      final json = await remote.deleteReview(params.reviewId, token);
      return Right(Review.fromJson(json));
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<Inventory>>> getInventories(
      GetInventoriesParams params) async {
    try {
      String? token = local.getToken();
      if (token == null) throw UnauthenticatedException();
      final json = await remote.getInventories(token, params);
      return Right(json.map((e) => Inventory.fromJson(e)).toList());
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, Inventory>> getInventory(
      GetInventoryParams params) async {
    try {
      String? token = local.getToken();
      if (token == null) throw UnauthenticatedException();
      final json = await remote.getInventory(params.inventoryId, token);
      return Right(Inventory.fromJson(json));
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, Rescue>> getRescue(GetRescueParams params) async {
    try {
      String? token = local.getToken();
      if (token == null) throw UnauthenticatedException();
      User? user = local.getUser();
      if (user == null) throw UnauthenticatedException();

      final rescueJson = await remote.getRescue(params.rescueId, token);
      final rescueInventoriesJson = await remote.getRescueInventoriesForRescue(
          token,
          GetRescueInventoriesParams(user.role, user.id),
          rescueJson['id']);
      return Right(
          Rescue.fromJson(rescueJson, calculateTotal(rescueInventoriesJson)));
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<Rescue>>> getRescues(
      GetRescuesParams params) async {
    try {
      String? token = local.getToken();
      if (token == null) throw UnauthenticatedException();
      User? user = local.getUser();
      if (user == null) throw UnauthenticatedException();

      List<Rescue> rescues = [];
      final rescuesJson =
          await remote.getRescues(token, GetRescuesParams(user.role, user.id));
      for (var rescueJson in rescuesJson) {
        final rescueInventoriesJson =
            await remote.getRescueInventoriesForRescue(
                token,
                GetRescueInventoriesParams(user.role, user.id),
                rescueJson['id']);

        rescues.add(
            Rescue.fromJson(rescueJson, calculateTotal(rescueInventoriesJson)));
      }
      return Right(rescues);
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, Review>> getReview(GetReviewParams params) async {
    try {
      String? token = local.getToken();
      if (token == null) throw UnauthenticatedException();
      final json = await remote.getInventory(params.reviewId, token);
      return Right(Review.fromJson(json));
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<Review>>> getReviews(NoParams params) async {
    try {
      String? token = local.getToken();
      if (token == null) throw UnauthenticatedException();
      final json = await remote.getReviews(token);
      return Right(json.map((e) => Review.fromJson(e)).toList());
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, Inventory>> updateInventory(
      UpdateInventoryParams params) async {
    try {
      String? token = local.getToken();
      if (token == null) throw UnauthenticatedException();
      final json = await remote.updateInventory(params, token);
      return Right(Inventory.fromJson(json));
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, Rescue>> updateRescue(
      UpdateRescueParams params) async {
    try {
      String? token = local.getToken();
      if (token == null) throw UnauthenticatedException();
      User? user = local.getUser();
      if (user == null) throw UnauthenticatedException();

      final rescueJson = await remote.updateRescue(params, token);
      final rescueInventoriesJson = await remote.getRescueInventoriesForRescue(
          token,
          GetRescueInventoriesParams(user.role, user.id),
          rescueJson['id']);
      return Right(
          Rescue.fromJson(rescueJson, calculateTotal(rescueInventoriesJson)));
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, Review>> updateReview(
      UpdateReviewParams params) async {
    try {
      String? token = local.getToken();
      if (token == null) throw UnauthenticatedException();
      final json = await remote.updateReview(params, token);
      return Right(Review.fromJson(json));
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, User>> getUser(NoParams params) async {
    try {
      User? user = local.getUser();
      return user == null
          ? Left(OtherFailure('Could not retrieve user'))
          : Right(user);
    } on CacheException {
      return Left(CacheFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getVendors(NoParams params) async {
    try {
      String? token = local.getToken();
      if (token == null) throw UnauthenticatedException();
      final json = await remote.getVendors(token);
      return Right(json.map((e) => User.fromJson(e)).toList());
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<RescueInventory>>> getRescueInventories(
      GetRescueInventoriesParams params) async {
    try {
      String? token = local.getToken();
      if (token == null) throw UnauthenticatedException();
      final json = await remote.getRescueInventories(token, params);

      if (json.isEmpty) return const Right([]);

      final rescueJson = json[0]['Rescue'];
      User fii = User.fromJson(rescueJson['FII']);
      User vendor = User.fromJson(rescueJson['Vendor']);

      List<RescueInventory> rescueInventories = [];
      for (var rescueInventoryJson in json) {
        var inventoryJson = rescueInventoryJson['Inventory'];
        Inventory inventory = Inventory.fromJson(
          await remote.getInventory(inventoryJson['id'], token),
        );
        rescueInventories.add(RescueInventory.fromJson(rescueInventoryJson,
            fii: fii, vendor: vendor, inventory: inventory));
      }

      return Right(rescueInventories);
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, Rescue>> checkOut(CheckOutParams params) async {
    try {
      List foodsList = params.foods.values.toList();
      String? token = local.getToken();
      if (token == null) throw UnauthenticatedException();
      User? user = local.getUser();
      if (user == null) throw UnauthenticatedException();
      String code = getRandomString(100);
      final rescueJson = await remote.createRescue(
          CreateRescueParams(
              code: code, fiiId: user.id, vendorId: params.vendor.id),
          token);
      double total = 0;
      for (int i = 0; i < foodsList.length; i++) {
        int quantity = foodsList[i]['quantity'];
        Inventory food = foodsList[i]['food'];
        remote.createRescueInventory(
            code, quantity, food.id, rescueJson['id'], token);
        total += quantity * food.price;
      }
      return Right(Rescue.fromJson(
        rescueJson,
        total,
      ));
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, Rescue>> verifyCode(VerifyCodeParams params) async {
    try {
      String? token = local.getToken();
      if (token == null) throw UnauthenticatedException();
      User? user = local.getUser();
      if (user == null) throw UnauthenticatedException();

      final rescueJson = await remote.verifyCode(params, token);
      final rescueInventoriesJson = await remote.getRescueInventoriesForRescue(
          token,
          GetRescueInventoriesParams(user.role, user.id),
          rescueJson['id']);
      return Right(Rescue.fromJson(
        rescueJson,
        calculateTotal(rescueInventoriesJson),
      ));
    } on UnauthenticatedException {
      return Left(UnauthenticatedFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }

  String getRandomString(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random.secure();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  double calculateTotal(List<Map<String, dynamic>> json) {
    double total = 0;
    for (var e in json) {
      total += e['total'];
    }
    return total;
  }

  @override
  Future<Either<Failure, void>> logOut(NoParams params) async {
    try {
      local.clearToken();
      local.clearUser();
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    } on OtherException catch (e) {
      return Left(OtherFailure(e.errorMessage));
    }
  }
}
