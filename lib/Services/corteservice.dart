import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class CorteService {
  final String apiUrl =
      "http://190.171.244.211/wsVarios/wsBS.asmx"; // URL del servicio SOAP

  // Método para obtener rutas basado en el valor de la ruta seleccionada
  Future<void> obtenerCortes(int liCper) async {
    final soapBody = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <W0Corte_ObtenerRutas xmlns="http://activebs.net/">
      <liCper>$liCper</liCper>
    </W0Corte_ObtenerRutas>
  </soap:Body>
</soap:Envelope>
''';

    final headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://activebs.net/W0Corte_ObtenerRutas',
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: soapBody,
      );

      if (response.statusCode == 200) {
        // Parsear la respuesta SOAP
        final document = xml.XmlDocument.parse(response.body);
        final responseNode =
            document.findAllElements('W0Corte_ObtenerRutasResponse').first;
        final resultNode =
            responseNode.findElements('W0Corte_ObtenerRutasResult').first;

        // Aquí procesas el resultado que viene de la API SOAP (ejemplo de cómo procesar el XML)
        print('Respuesta de la API: ${resultNode.text}');

        // Aquí podrías agregar el código para mapear y mostrar los datos que lleguen
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción durante la solicitud SOAP: $e');
    }
  }
}
