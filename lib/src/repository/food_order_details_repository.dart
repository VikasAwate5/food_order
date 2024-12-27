import 'dart:convert';
import 'dart:io';

import 'package:food_order/src/repository/utils/utils.dart';
import 'package:http/http.dart' as http;

import 'model/food_order_details.dart';

abstract class FoodOrderDetailsRepository {
  Future<FoodOrderDetails> fetchOrderDetails({required int month});
}

class FoodOrderDetailsRepositoryImpl extends FoodOrderDetailsRepository {
  @override
  Future<FoodOrderDetails> fetchOrderDetails({required int month}) async {
    final foodOrderDetails = await fetchOrderDetailsFromApi(month: month);
    return foodOrderDetails;
  }

  Future<FoodOrderDetails> fetchOrderDetailsFromApi({int month = 1}) async {
    try {
      final response = await http.post(
        Uri.parse(Utils.baseUrl),
        body: json.encode({'month': '$month'}),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${Utils.token}",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final foodOrderDetails = FoodOrderDetails.fromJson(data);
        return foodOrderDetails;
      } else {
        throw Exception(
          'Failed to load order details : Status code: ${response.statusCode}',
        );
      }
    } catch (error) {
      throw Exception('Error fetching order details: $error');
    }
  }
}
