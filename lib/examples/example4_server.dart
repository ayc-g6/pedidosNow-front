/* En este ejemplo veremos como usar una API. El código es una versión simplificada
 * del código que pueden encontrar en src/services/server.dart
 */

// De esta forma hacemos imports
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

// Nos resulta útil tener una excepción definida
class ServerExceptionExample implements Exception {
  final String message;

  const ServerExceptionExample(this.message);

  @override
  String toString() => message;
}

class ServerExample {
  static const String google_url = 'www.google.com';

  /* Utilizamos métodos de clase pues es altamente práctico hacer
   * Server.googleSearch(9001)
   * sin necesidad de una instancia.
   */
  static Future<String> googleSearch(int param) async {
    final Map<String, dynamic> queryParams = {
      'q': 'how+to+flutter',
    };

    /* La URL está compuesta por el dominio, una dirección y query params.
     * En todo API Call necesitaremos un tipo de call (get, put, post, patch, delete, etc),
     * una URL,
     * uno o más headers (típicamente el del ejemplo alcanza)
     * un body (opcional, no válido en el GET)
     * El llamado a la API es asincrónico, por lo que necesitamos await.
     */
    final response = await http.get(
      Uri.https(google_url, '/search', queryParams),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      // body: Lo que quieras
    );

    // Revisamos el statusCode y según eso tomamos una acción
    switch (response.statusCode) {
      case HttpStatus.ok:
        // El get me devuelve un archivo html asi que lo puse como String...
        String body = jsonDecode(response.body);
        return body;
      case HttpStatus.notFound:
        // O el mensaje de error que te guste
        throw const ServerExceptionExample('Failed to reach server');
      default:
        throw const ServerExceptionExample('Unknown server error');
    }
  }
}

void makeAPICall() async {
  int overNineThousand = 9001;
  String paginaWeb = await ServerExample.googleSearch(overNineThousand);
  print(paginaWeb);
}
