import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  bool isLoggedIn = false; // Variable para almacenar el estado de autenticación

  static String get _baseUrl {
    if (kIsWeb) {
      return 'http://localhost:9000/api/users';
    } else if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:9000/api/users';
    } else {
      return 'http://localhost:9000/api/users';
    }
  }

  //login
  Future<Map<String, dynamic>> login(String email, String password) async {
  final url = Uri.parse('$_baseUrl/login');
  final body = json.encode({'email': email, 'password': password});

  try {
    print("Enviando solicitud POST a: $url");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print("Respuesta recibida con código: ${response.statusCode}");

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      

      if (responseData.containsKey('userId')) {

        
        isLoggedIn = true; 
        return {'userId': responseData['userId']};  // Almaceno el ID del usuario para usarlo más tarde en la aplicación


      } else {
        return {'error': 'Respuesta inválida del servidor'};
      }
    } else if (response.statusCode == 401) {
      return {'error': 'Email o contraseña incorrectos'};
    } else {
      return {'error': 'Error del servidor: ${response.statusCode}'};
    }
  } catch (e) {
    print("Error al realizar la solicitud: $e");
    return {'error': 'Error de conexión. Por favor, inténtalo de nuevo.'};
  }
}

  void logout() {
    isLoggedIn = false; // Cambia el estado de autenticación a no autenticado
    print("Sessió tancada");
  }
}
