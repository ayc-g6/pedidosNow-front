import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/order.dart';

class ServerException implements Exception {
  final String message;

  const ServerException(this.message);

  @override
  String toString() => message;
}

class Server {
  // TODO Cambiar por valor correcto
  static const String apiUrl = 'pedidosnow-back.herokuapp.com';
  // static const String apiUrl = 'localhost:8000';

  static Future<void> signUpCustomer(
      String username, String email, String password) async {
    final body = {'username': username, 'email': email, 'password': password};

    final response = await http.post(
      Uri.https(apiUrl, '/customer/'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(body),
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return;
      case HttpStatus.badRequest:
        String errorMsg = jsonDecode(response.body)['detail'];
        throw ServerException(errorMsg);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }

  static Future<void> signUpBusiness(String businessName, String address,
      String email, String password) async {
    final body = {
      'business_name': businessName,
      'address': address,
      'email': email,
      'password': password
    };

    final response = await http.post(
      Uri.https(apiUrl, '/business/'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(body),
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return;
      case HttpStatus.badRequest:
        String errorMsg = jsonDecode(response.body)['detail'];
        throw ServerException(errorMsg);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }

  static Future<Map<String, String>> logIn(
      String email, String password) async {
    final body = {
      'username': email,
      'password': password,
      'scope': 'business customer'
    };

    final response = await http.post(
      Uri.https(apiUrl, '/token/'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      },
      body: body,
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        Map<String, String> accessTokenAndScope =
            Map.castFrom(json.decode(response.body));
        return accessTokenAndScope;
      case HttpStatus.unauthorized:
        String errorMsg = jsonDecode(response.body)['detail'];
        throw ServerException(errorMsg);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }

  static Future<void> createProduct(Product product, String accessToken) async {
    final response = await http.post(
      Uri.https(apiUrl, '/product/'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader:  'Bearer $accessToken',
      },
      body: json.encode(product),
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return;
      case HttpStatus.unauthorized:
        String errorMsg = jsonDecode(response.body);
        throw ServerException(errorMsg);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }

  static Future<Product> getProduct(int productId) async {
    final response = await http.get(
      Uri.https(apiUrl, '/product/$productId'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return Product.fromJson(jsonDecode(response.body));
      case HttpStatus.notFound:
        String errorMsg = jsonDecode(response.body)['detail'];
        throw ServerException(errorMsg);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }

  static Future<List<Product>> getProducts(int pageKey,
      {String? productName}) async {
    final Map<String, dynamic> queryParams = {};
    if (productName != null) queryParams['name'] = productName;

    final response = await http.get(
      Uri.https(apiUrl, '/product/all/$pageKey', queryParams),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        List<Product> productsList(String str) => List<Product>.from(
            json.decode(str).map((x) => Product.fromJson(x)));

        return productsList(response.body);
      case HttpStatus.unauthorized:
        String errorMsg = jsonDecode(response.body);
        throw ServerException(errorMsg);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }

  static Future<void> createOrder(Order order, String? accessToken) async {
    print(json.encode(order));
    print(accessToken);
    final response = await http.post(
      Uri.https(apiUrl, '/order/'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
      body: json.encode(order),
    );

    print(response.statusCode);
    print(jsonDecode(response.body));
    switch (response.statusCode) {
      case HttpStatus.ok:
        return;
      case HttpStatus.unauthorized:
        String errorMsg = jsonDecode(response.body);
        throw ServerException(errorMsg);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }

  static Future<List<dynamic>> getOrders(
      String accessToken, int pageKey) async {
    final response = await http.get(
      Uri.https(apiUrl, '/order/all/$pageKey'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return jsonDecode(response.body);
      case HttpStatus.unauthorized:
        String errorMsg = jsonDecode(response.body);
        throw ServerException(errorMsg);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }
}
