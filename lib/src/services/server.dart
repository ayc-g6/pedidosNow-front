import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

// TODO Review returns and throws

class ServerException implements Exception {
  final String message;
  final int code;

  const ServerException(this.message, {this.code = 0});

  @override
  String toString() => message;

  bool isAuthException() => code == 401;
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

  static Future<void> signUpDelivery(
      String username, String email, String password) async {
    final body = {'username': username, 'email': email, 'password': password};

    final response = await http.post(
      Uri.https(apiUrl, '/delivery/'),
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
      'scope': 'business customer delivery'
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

  static Future<Map<String, dynamic>> getMyBusiness(String accessToken) async {
    final response = await http.get(
      Uri.https(apiUrl, '/business'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      },
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return jsonDecode(response.body);
      case HttpStatus.unauthorized:
        String errorMsg = jsonDecode(response.body)['detail'];
        throw ServerException(errorMsg);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }

  static Future<Map<String, dynamic>> getBusiness(String businessID) async {
    final response = await http.get(
      Uri.https(apiUrl, '/business/$businessID'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return jsonDecode(response.body);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }

  static Future<void> createProduct(
    String accessToken, {
    required String name,
    required String description,
    required double price,
    required double calories,
    required double carbs,
    required double protein,
    required double fat,
  }) async {
    final body = {
      'name': name,
      'description': description,
      'price': price,
      'calories': calories,
      'carbs': carbs,
      'protein': protein,
      'fat': fat
    };

    final response = await http.post(
      Uri.https(apiUrl, '/product/'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return;
      case HttpStatus.unauthorized:
        String errorMsg = jsonDecode(response.body)['detail'];
        throw ServerException(errorMsg);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }

  static Future<Map<String, dynamic>> getProduct(int productId) async {
    final Map<String, dynamic> queryParams = {
      'id': "$productId",
    };

    final response = await http.get(
      Uri.https(apiUrl, '/product/all/0', queryParams),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return jsonDecode(response.body)[0];
      case HttpStatus.notFound:
        String errorMsg = jsonDecode(response.body)['detail'];
        throw ServerException(errorMsg);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }

  static Future<List<dynamic>> getProducts(int pageKey,
      [String? productName]) async {
    final Map<String, dynamic> queryParams = {};
    if (productName != null && productName.isNotEmpty) {
      queryParams['name'] = productName;
    }

    final response = await http.get(
      Uri.https(apiUrl, '/product/all/$pageKey', queryParams),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return jsonDecode(response.body);
      case HttpStatus.unauthorized:
        String errorMsg = jsonDecode(response.body)['detail'];
        throw ServerException(errorMsg, code: response.statusCode);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }

  static Future<List<dynamic>> getBussinessProducts(
      int pageKey, String? accessToken) async {
    final response = await http.get(
      Uri.https(apiUrl, '/business/product/$pageKey'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      },
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return jsonDecode(response.body);
      case HttpStatus.unauthorized:
        String errorMsg = jsonDecode(response.body)['detail'];
        throw ServerException(errorMsg, code: response.statusCode);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }

  static Future<void> createOrder(String accessToken,
      {required int productId,
      required String businessId,
      required String deliveryAddress,
      required int quantity}) async {
    final body = {
      'product_id': productId,
      'business_id': businessId,
      'delivery_address': deliveryAddress,
      'quantity': quantity,
    };

    final response = await http.post(
      Uri.https(apiUrl, '/order/'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
      body: jsonEncode(body),
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return;
      case HttpStatus.unauthorized:
        String errorMsg = jsonDecode(response.body)['detail'];
        throw ServerException(errorMsg);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }

  static Future<List<dynamic>> getBusinessOrders(
      String accessToken, int pageKey) async {
    final response = await http.get(
      Uri.https(apiUrl, '/business/order/$pageKey'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return jsonDecode(response.body);
      case HttpStatus.unauthorized:
        String errorMsg = jsonDecode(response.body)['detail'];
        throw ServerException(errorMsg, code: response.statusCode);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }

  static Future<List<dynamic>> getCustomerOrders(
      String accessToken, int pageKey) async {
    final response = await http.get(
      Uri.https(apiUrl, '/customer/order/$pageKey'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return jsonDecode(response.body);
      case HttpStatus.unauthorized:
        String errorMsg = jsonDecode(response.body)['detail'];
        throw ServerException(errorMsg, code: response.statusCode);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }

  static Future<List<dynamic>> getDeliveryOrders(
      String accessToken, int pageKey) async {
    final Map<String, dynamic> queryParams = {
      'states': ["0"],
    };

    final response = await http.get(
      Uri.https(apiUrl, '/order/all/$pageKey', queryParams),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return jsonDecode(response.body);
      case HttpStatus.unauthorized:
        String errorMsg = jsonDecode(response.body)['detail'];
        throw ServerException(errorMsg, code: response.statusCode);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }

  static Future<void> updateOrderState(
      String accessToken, int orderId, int orderState) async {
    final Map<String, dynamic> queryParams = {
      'state': '$orderState',
    };

    final response = await http.patch(
      Uri.https(apiUrl, '/order/$orderId', queryParams),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return;
      case HttpStatus.unauthorized:
        String errorMsg = jsonDecode(response.body)['detail'];
        throw ServerException(errorMsg, code: response.statusCode);
      case HttpStatus.conflict:
        String errorMsg = jsonDecode(response.body)['detail'];
        throw ServerException(errorMsg);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }

  static Future<Map<String, dynamic>> getOrder(int orderId) async {
    final response = await http.get(
      Uri.https(apiUrl, '/order/$orderId'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return jsonDecode(response.body);
      case HttpStatus.notFound:
        String errorMsg = jsonDecode(response.body)['detail'];
        throw ServerException(errorMsg);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }

  static Future<int> getWork(String accessToken) async {
    final response = await http.get(
      Uri.https(apiUrl, '/delivery/order'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return jsonDecode(response.body)['order_id'];
      case HttpStatus.unauthorized:
        String errorMsg = jsonDecode(response.body)['detail'];
        throw ServerException(errorMsg, code: response.statusCode);
      case HttpStatus.notFound:
        String errorMsg = jsonDecode(response.body)['detail'];
        throw ServerException(errorMsg);
      default:
        throw const ServerException('Server Error - Please try again');
    }
  }
}
