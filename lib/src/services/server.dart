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
  static const String api_url = '';
}
