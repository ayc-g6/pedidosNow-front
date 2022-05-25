import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

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
      Uri.https(apiUrl, '/business/'),
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
      Uri.https(apiUrl, '/token/'),
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
}
