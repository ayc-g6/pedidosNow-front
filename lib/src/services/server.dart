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
  static const String apiUrl = 'localhost:8000';

  Future<void> signUp(String email, String password) async {
    final body = {
      'email': email,
      'password': password,
    };

    final response = await http.post(
      Uri.https(apiUrl, '/auth'),
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
}
