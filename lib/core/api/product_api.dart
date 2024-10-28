import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ProductApi {
  Logger logger = Logger();
  final String baseUrl = 'https://dummyjson.com';

  // get all products
  Future<List<Map<String, dynamic>>> getAllProducts({int limit = 30}) async {
    Uri url = Uri.parse("$baseUrl/products?limit=$limit");
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        return data['products'];
      } else {
        logger.e("ERROR OCCURRED: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      logger.e("ERROR OCCURRED: $e");
      return [];
    }
  }

  // get products by category

  Future<List> getProductsByCategory(String category, {int limit = 4}) async {
    Uri url = Uri.parse("$baseUrl/products/category/$category?limit=$limit");
    List<Map<String, dynamic>> product = [];

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        product = List<Map<String, dynamic>>.from(data["products"]);
        product.shuffle();
      } else {
        logger.e("ERROR OCCURRED: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("ERROR OCCURRED: $e");
    }

    return product;
  }

  // get product by id

  Future<Map> getProductById(String id) async {
    Uri url = Uri.parse("$baseUrl/products/$id");

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        return data['product'];
      } else {
        logger.e("ERROR OCCURRED: ${response.statusCode}");
        return {};
      }
    } catch (e) {
      logger.e("ERROR OCCURRED: $e");
      return {};
    }
  }

  // search products by name

  // sort product by filters
}
