import 'dart:convert';
//import 'dart:ffi';
import 'package:http/http.dart' as http;
import '../utils/apiBack.dart';
import '../models/loginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<bool> login(String login, String password) async {
    final url = Uri.parse('http://190.171.244.211:8080/wsVarios/wsAd.asmx');
    final soapEnvelope = '''
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
      <soap:Body>
        <tem:ValidarLoginPassword>
          <tem:login>$login</tem:login>
          <tem:password>$password</tem:password>
        </tem:ValidarLoginPassword>
      </soap:Body>
    </soap:Envelope>
    ''';

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
          'SOAPAction': 'http://tempuri.org/ValidarLoginPassword',
        },
        body: soapEnvelope,
      );

      if (response.statusCode == 200) {
        // Parsear la respuesta SOAP
        final responseBody = response.body;
        print("Respuesta del servidor: $responseBody");

        // Extraer datos relevantes de la respuesta XML
        if (responseBody.contains('<ValidarLoginPasswordResult>true</ValidarLoginPasswordResult>')) {
          return true; // Login exitoso
        } else {
          return false; // Login fallido
        }
      } else {
        print('Error en el servidor: ${response.statusCode}');
        throw Exception('Error en el servidor');
      }
    } catch (e) {
      print('Error durante la autenticación: $e');
      throw Exception('Error en la autenticación');
    }
  
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', userData['token']);
    await prefs.setString('refreshToken', userData['refreshToken']);
    await prefs.setString('expirationTime', userData['expirationTime']);
    await prefs.setString('role', userData['role']);
        await prefs.setString('name', userData['name']);

    await prefs.setInt('id', userData['id']);

  }
}

Future<Map<String, dynamic>?> getUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  String? refreshToken = prefs.getString('refreshToken');
  String? expirationTime = prefs.getString('expirationTime');
  String? role = prefs.getString('role');
    String? name = prefs.getString('name');

  int? id = prefs.getInt('id');

  if (token != null && refreshToken != null && expirationTime != null && role != null) {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'expirationTime': expirationTime,
      'role': role,
      'name': role,
      'id': id,
    };
  } else {
    return null;
  }
}

Future<void> clearUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

Future<bool> checkIfLoggedIn() async {
  Map<String, dynamic>? userData = await getUserData();
  return userData != null;
}
