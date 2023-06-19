import 'dart:convert';
import 'dart:developer';

import 'package:chop/core/constants/constants.dart';
import 'package:chop/core/failure/error.dart';
import 'package:chop/domain/use_cases/create_inventory_use_case.dart';
import 'package:chop/domain/use_cases/create_rescue_use_case.dart';
import 'package:chop/domain/use_cases/create_review_use_case.dart';
import 'package:chop/domain/use_cases/get_inventories_use_case.dart';
import 'package:chop/domain/use_cases/get_rescue_inventories.dart';
import 'package:chop/domain/use_cases/login_use_case.dart';
import 'package:chop/domain/use_cases/register_use_case.dart';
import 'package:chop/domain/use_cases/update_inventory_use_case.dart';
import 'package:chop/domain/use_cases/update_rescue_use_case.dart';
import 'package:chop/domain/use_cases/update_review_use_case.dart';
import 'package:chop/domain/use_cases/verify_code_use_case.dart';
import 'package:http/http.dart' as http;

import '../../domain/use_cases/get_rescues_use_case.dart';

abstract class ChopRemoteDataSource {
  Future<Map<String, dynamic>> login(LoginParams params);
  Future<Map<String, dynamic>> register(RegisterParams params);
  Future<List<Map<String, dynamic>>> getInventories(
      String token, GetInventoriesParams params);
  Future<List<Map<String, dynamic>>> getRescues(
      String token, GetRescuesParams getRescueParams);
  Future<List<Map<String, dynamic>>> getReviews(String token);
  Future<Map<String, dynamic>> getInventory(int inventoryId, String token);
  Future<Map<String, dynamic>> getRescue(int rescueId, String token);
  Future<Map<String, dynamic>> getReview(int reviewId, String token);
  Future<Map<String, dynamic>> createInventory(
      CreateInventoryParams params, String token);
  Future<Map<String, dynamic>> createRescue(
      CreateRescueParams params, String token);
  Future<Map<String, dynamic>> createRescueInventory(
      String code, int quantity, int inventoryId, int rescueId, String token);
  Future<Map<String, dynamic>> createReview(
      CreateReviewParams params, String token);
  Future<Map<String, dynamic>> deleteInventory(int inventoryId, String token);
  Future<Map<String, dynamic>> deleteRescue(int rescueId, String token);
  Future<Map<String, dynamic>> deleteReview(int reviewId, String token);
  Future<Map<String, dynamic>> updateInventory(
      UpdateInventoryParams params, String token);
  Future<Map<String, dynamic>> updateRescue(
      UpdateRescueParams params, String token);
  Future<Map<String, dynamic>> updateReview(
      UpdateReviewParams params, String token);
  Future<List<Map<String, dynamic>>> getVendors(String token);
  Future<List<Map<String, dynamic>>> getFiis(String token);
  Future<List<Map<String, dynamic>>> getRescueInventories(
      String token, GetRescueInventoriesParams params);
  Future<List<Map<String, dynamic>>> getRescueInventoriesForRescue(
      String token, GetRescueInventoriesParams params, int rescueId);
  Future<Map<String, dynamic>> verifyCode(
      VerifyCodeParams params, String token);
}

class ChopRemoteDataSourceImpl extends ChopRemoteDataSource {
  final http.Client client;

  ChopRemoteDataSourceImpl(this.client);

  handleResponse(http.Response response, {bool? first}) {
    log(response.body);
    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 403) throw UnauthenticatedException();
    if ((response.statusCode == 200 &&
            (responseBody['status'] is bool
                ? responseBody['status']
                : responseBody['status'] == 200)) ||
        response.statusCode == 201) {
      if (first == null) {
        return responseBody['data'];
      } else {
        return responseBody['data'][0];
      }
    }
    throw OtherException(responseBody['message'] ?? 'An error occurred.');
  }

  @override
  Future<Map<String, dynamic>> login(LoginParams params) async {
    http.Response response;
    try {
      response = await http.post(Uri.parse('$domain/auth/login'),
          body:
              json.encode({'email': params.email, 'password': params.password}),
          headers: {'Content-Type': 'application/json'});
    } on Exception {
      throw NetworkException();
    }
    return handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> register(RegisterParams params) async {
    http.Response response;
    try {
      final body = {
        "name": params.name,
        "email": params.email,
        "password": params.password,
        "phone": params.phone,
        "role": params.role
      };
      if (params.role == 'VENDOR') {
        body.addAll({"location": params.location!, "address": params.address!});
      }
      response = await http.post(Uri.parse('$domain/auth/register'),
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'});
    } on Exception {
      throw NetworkException();
    }
    return handleResponse(response);
  }

  @override
  Future<List<Map<String, dynamic>>> getInventories(
      String token, GetInventoriesParams params) async {
    http.Response response;
    try {
      response = await http.get(
          Uri.parse(
              '$domain/inventory/${params.vendorId == null ? '' : 'vendor/${params.vendorId!}'}'),
          headers: {'Authorization': 'Bearer $token'});
    } on Exception {
      throw NetworkException();
    }

    dynamic handledResponse = handleResponse(response);

    if (handledResponse is List) {
      return handledResponse
          .map((inventory) => inventory as Map<String, dynamic>)
          .toList();
    }
    return handledResponse;
  }

  @override
  Future<List<Map<String, dynamic>>> getRescues(
      String token, GetRescuesParams params) async {
    http.Response response;
    try {
      response = await http.get(
          Uri.parse(
              '$domain/rescue/${params.role.toLowerCase()}/${params.userId}'),
          headers: {'Authorization': 'Bearer $token'});
    } on Exception {
      throw NetworkException();
    }

    dynamic handledResponse = handleResponse(response);

    if (handledResponse is List) {
      return handledResponse
          .map((inventory) => inventory as Map<String, dynamic>)
          .toList();
    }
    return handledResponse;
  }

  @override
  Future<List<Map<String, dynamic>>> getReviews(String token) async {
    http.Response response;
    try {
      response = await http.get(Uri.parse('$domain/review'),
          headers: {'Authorization': 'Bearer $token'});
    } on Exception {
      throw NetworkException();
    }

    dynamic handledResponse = handleResponse(response);

    if (handledResponse is List) {
      return handledResponse
          .map((inventory) => inventory as Map<String, dynamic>)
          .toList();
    }
    return handledResponse;
  }

  @override
  Future<Map<String, dynamic>> createInventory(
      CreateInventoryParams params, String token) async {
    http.Response response;
    try {
      response = await http.post(Uri.parse('$domain/inventory'),
          body: json.encode({
            "name": params.name,
            "category": params.category,
            "stock": params.stock,
            "price": params.price,
            "discount": params.discount,
            "vendor_id": params.vendorId
          }),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          });
    } on Exception {
      throw NetworkException();
    }
    return handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> createRescue(
      CreateRescueParams params, String token) async {
    http.Response response;
    try {
      response = await http.post(Uri.parse('$domain/rescue'),
          body: json.encode({
            "code": params.code,
            "fii_id": params.fiiId,
            "vendor_id": params.vendorId,
            "price": 15
          }),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          });
    } on Exception {
      throw NetworkException();
    }
    return handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> createReview(
      CreateReviewParams params, String token) async {
    http.Response response;
    try {
      response = await http.post(Uri.parse('$domain/review'),
          body: json.encode({
            "star": params.star,
            "description": params.description,
            "vendor_id": params.vendorId,
            "fii_id": params.fiiId
          }),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          });
    } on Exception {
      throw NetworkException();
    }
    return handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> deleteInventory(
      int inventoryId, String token) async {
    http.Response response;
    try {
      response = await http.delete(Uri.parse('$domain/inventory/$inventoryId'),
          headers: {'Authorization': 'Bearer $token'});
    } on Exception {
      throw NetworkException();
    }
    return handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> deleteRescue(int rescueId, String token) async {
    http.Response response;
    try {
      response = await http.delete(Uri.parse('$domain/rescue?$rescueId'),
          headers: {'Authorization': 'Bearer $token'});
    } on Exception {
      throw NetworkException();
    }
    return handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> deleteReview(int reviewId, String token) async {
    http.Response response;
    try {
      response = await http.delete(Uri.parse('$domain/review/$reviewId'),
          headers: {'Authorization': 'Bearer $token'});
    } on Exception {
      throw NetworkException();
    }
    return handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> getInventory(
      int inventoryId, String token) async {
    http.Response response;
    try {
      response = await http.get(Uri.parse('$domain/inventory/$inventoryId'),
          headers: {'Authorization': 'Bearer $token'});
    } on Exception {
      throw NetworkException();
    }
    return handleResponse(response, first: true);
  }

  @override
  Future<Map<String, dynamic>> getRescue(int rescueId, String token) async {
    http.Response response;
    try {
      response = await http.get(Uri.parse('$domain/rescue/$rescueId'),
          headers: {'Authorization': 'Bearer $token'});
    } on Exception {
      throw NetworkException();
    }
    return handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> getReview(int reviewId, String token) async {
    http.Response response;
    try {
      response = await http.get(Uri.parse('$domain/review/$reviewId'),
          headers: {'Authorization': 'Bearer $token'});
    } on Exception {
      throw NetworkException();
    }
    return handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> updateInventory(
      UpdateInventoryParams params, String token) async {
    http.Response response;
    try {
      response = await http.put(
          Uri.parse('$domain/inventory/${params.inventoryId}'),
          body: json.encode({
            "name": params.name,
            "category": params.category,
            "stock": params.stock,
            "price": params.price,
            "discount": params.discount,
            "vendor_id": params.vendorId
          }),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          });
    } on Exception {
      throw NetworkException();
    }
    return handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> updateRescue(
      UpdateRescueParams params, String token) async {
    http.Response response;
    try {
      response = await http.put(Uri.parse('$domain/rescue/${params.rescueId}'),
          body: json.encode({"quantity": params.quantity}),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          });
    } on Exception {
      throw NetworkException();
    }
    return handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> updateReview(
      UpdateReviewParams params, String token) async {
    http.Response response;
    try {
      response = await http.put(Uri.parse('$domain/review/${params.reviewId}'),
          body: json.encode({"star": params.star}),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          });
    } on Exception {
      throw NetworkException();
    }
    return handleResponse(response);
  }

  @override
  Future<List<Map<String, dynamic>>> getVendors(String token) async {
    http.Response response;
    try {
      response = await http.get(Uri.parse('$domain/vendor'),
          headers: {'Authorization': 'Bearer $token'});
    } on Exception {
      throw NetworkException();
    }

    dynamic handledResponse = handleResponse(response);

    if (handledResponse is List) {
      return handledResponse
          .map((inventory) => inventory as Map<String, dynamic>)
          .toList();
    }
    return handledResponse;
  }

  @override
  Future<List<Map<String, dynamic>>> getFiis(String token) async {
    http.Response response;
    try {
      response = await http.get(Uri.parse('$domain/fii'),
          headers: {'Authorization': 'Bearer $token'});
    } on Exception {
      throw NetworkException();
    }

    dynamic handledResponse = handleResponse(response);

    if (handledResponse is List) {
      return handledResponse
          .map((inventory) => inventory as Map<String, dynamic>)
          .toList();
    }
    return handledResponse;
  }

  @override
  Future<List<Map<String, dynamic>>> getRescueInventories(
      String token, GetRescueInventoriesParams params) async {
    http.Response response;
    try {
      response = await http.get(
          Uri.parse(
              '$domain/inventory-rescue/${params.role.toLowerCase()}/${params.userId}'),
          headers: {'Authorization': 'Bearer $token'});
    } on Exception {
      throw NetworkException();
    }

    List handledResponse = handleResponse(response);
    List<Map<String, dynamic>> rescueInventoryJsonList = [];

    for (List rescueCollection in handledResponse) {
      for (var rescueInventoryJson in rescueCollection) {
        rescueInventoryJsonList.add(rescueInventoryJson);
      }
    }

    return rescueInventoryJsonList;
  }

  @override
  Future<List<Map<String, dynamic>>> getRescueInventoriesForRescue(
      String token, GetRescueInventoriesParams params, int rescueId) async {
    http.Response response;
    try {
      response = await http.get(
          Uri.parse('$domain/inventory-rescue/rescue/$rescueId'),
          headers: {'Authorization': 'Bearer $token'});
    } on Exception {
      throw NetworkException();
    }

    dynamic handledResponse = handleResponse(response);

    if (handledResponse is List) {
      return handledResponse
          .map((inventory) => inventory as Map<String, dynamic>)
          .toList();
    }
    return handledResponse;
  }

  @override
  Future<Map<String, dynamic>> createRescueInventory(String code, int quantity,
      int inventoryId, int rescueId, String token) async {
    http.Response response;
    try {
      response = await http.post(Uri.parse('$domain/inventory-rescue'),
          body: json.encode({
            "code": code,
            "quantity": quantity,
            "inventory_id": inventoryId,
            "rescue_id": rescueId
          }),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          });
    } on Exception {
      throw NetworkException();
    }
    return handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> verifyCode(
      VerifyCodeParams params, String token) async {
    http.Response response;
    try {
      response = await http.post(Uri.parse('$domain/verify-code'),
          body: json.encode({
            "rescue_id": params.rescueId,
            "code": params.code,
          }),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          });
    } on Exception {
      throw NetworkException();
    }
    return handleResponse(response);
  }
}
