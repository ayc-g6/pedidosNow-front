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
  // static const String apiUrl = 'pedidosnow-back.herokuapp.com';
  static const String apiUrl = 'localhost:8000';

  static Future<void> getUserId() async {

    final response = await http.get(
      Uri.http(apiUrl, '/token/'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    print(response.statusCode);
    print(response.body);
    switch (response.statusCode) {
      case HttpStatus.ok:
        return jsonDecode(response.body);
      case HttpStatus.badRequest:
        String errorMsg = jsonDecode(response.body)['detail'];
        throw ServerException(errorMsg);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }

  static Future<void> signUpCustomer(
      String username, String email, String password) async {
    final body = {'username': username, 'email': email, 'password': password};

    final response = await http.post(
      Uri.http(apiUrl, '/customer/'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(body),
    );

    print(response.statusCode);
    print(response.body);
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
      Uri.http(apiUrl, '/business/'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(body),
    );

    print(response.statusCode);
    print(response.body);
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
      Uri.http(apiUrl, '/token/'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );

    print(response.statusCode);
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

  static Future<void> createProduct(Product product) async {
    final response = await http.post(
      Uri.http(apiUrl, '/product/'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(product),
    );
    print(response.statusCode);
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
      Uri.http(apiUrl, '/product/$productId'),
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

  static Future<List<Product>> getProducts(int pageKey) async {
    final response = await http.get(
      Uri.http(apiUrl, '/product/all/$pageKey'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        'Content-Type': 'application/json',
      },
    );
    print(response.statusCode);
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

  static Future<void> createOrder(Product product, int customerId) async {
    final response = await http.post(
      Uri.http(apiUrl, '/order/'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(product.name),
    );
    print(response.statusCode);
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
}
