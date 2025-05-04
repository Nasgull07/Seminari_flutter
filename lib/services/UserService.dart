import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class UserService {
  static String get baseUrl {
  if (kIsWeb) {
    return 'http://localhost:9000/api/users';
  } 
  else if (!kIsWeb && Platform.isAndroid) {
    return 'http://10.0.2.2:9000/api/users';
  } 
  else {
    return 'http://localhost:9000/api/users';
  }
}

  static Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Error en carregar usuaris');
    }
  }

  static Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear usuari: ${response.statusCode}');
    }
  }


  ///** -------------------  Obté un usuari per ID  ------------------- **//
  static Future<User> getUserById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error a l'obtenir usuari: ${response.statusCode}");
    }
  }


  ///** -------------------  Actualitza un usuari  ------------------- **//
  static Future<bool> updateUser(User user) async {
    final url = Uri.parse('http://localhost:9000/api/users/${user.id}');
    final body = json.encode({
      'name': user.name,
      'age': user.age,
      'email': user.email,
    });

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error al actualizar el usuario: $e');
      return false;
    }
  }

  /// -------------------  Cambia la contrasenya de l'usuari  ------------------- ///

  static Future<bool> changePassword(
    String userId,
    String currentPassword,
    String newPassword,
  ) async {
    final url = Uri.parse('http://localhost:9000/api/users/$userId/change-password');
    final body = json.encode({
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error al cambiar la contraseña: $e');
      return false;
    }
  }

  static Future<bool> deleteUser(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error eliminant usuari: ${response.statusCode}');
    }
  }
}
