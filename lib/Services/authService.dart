import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml; // Para manejar XML
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<bool> login(String login, String password) async {
    final url = Uri.parse('http://190.171.244.211:8080/wsVarios/wsAd.asmx');

    // Cuerpo de la solicitud SOAP
    final soapBody = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <ValidarLoginPassword xmlns="http://tempuri.org/">
      <lsLogin>$login</lsLogin>
      <lsPassword>$password</lsPassword>
    </ValidarLoginPassword>
  </soap:Body>
</soap:Envelope>
''';

    // Encabezados (ajustados según la configuración de Postman)
    final headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': '"http://tempuri.org/ValidarLoginPassword"',
    };

    try {
      // Envío de la solicitud POST
      final response = await http.post(
        url,
        headers: headers,
        body: soapBody,
      );

      // Mostrar el estado y la respuesta para depuración
      print("Estado de la solicitud: ${response.statusCode}");
      print("Cuerpo de la respuesta: ${response.body}");

      if (response.statusCode == 200) {
        // Usar expresión regular para extraer el contenido de ValidarLoginPasswordResult
        final regExp = RegExp(
            r'<ValidarLoginPasswordResult>(.*?)</ValidarLoginPasswordResult>');
        final match = regExp.firstMatch(response.body);

        if (match != null) {
          final result = match.group(1);
          print('Resultado del login: $result');

          // Verificar si el resultado contiene el valor esperado
          if (result != null && result.startsWith('OK')) {
            return true; // Login exitoso
          }
        }

        return false; // Credenciales incorrectas o error en el formato
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Excepción durante el login: $e');
      return false;
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

  if (token != null &&
      refreshToken != null &&
      expirationTime != null &&
      role != null) {
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
