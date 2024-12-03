import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class ImportarCortesPage extends StatefulWidget {
  @override
  _ImportCortesPageState createState() => _ImportCortesPageState();
}

class _ImportCortesPageState extends State<ImportarCortesPage> {
  String? _selectedRoute = "Seleccionar...";
  List<String> _routes = ["Seleccionar...", "TODAS LAS RUTAS"];
  final TextEditingController _codigoFijoController = TextEditingController();
  String _serverResponse = "";
  List<Map<String, String>> _tablesData = []; // Almacena datos procesados

  @override
  void dispose() {
    _codigoFijoController.dispose();
    super.dispose();
  }

  Future<void> _sendData({required bool isImport}) async {
    final url = "http://190.171.244.211:8080/wsVarios/wsBS.asmx";

    final codigoFijo = int.tryParse(_codigoFijoController.text.trim());
    final liCper = _selectedRoute == "TODAS LAS RUTAS" ? 0 : (codigoFijo ?? 0);

    if (liCper == null || liCper == 0 && _selectedRoute == "Seleccionar...") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, selecciona una ruta o ingresa un código válido.")),
      );
      return;
    }

    // SOAP Envelope diferente según el botón
    final soapEnvelope = isImport
        ? '''<?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Body>
          <W2Corte_ReporteParaCortesSIG xmlns="http://activebs.net/">
            <liNrut>${liCper}</liNrut>
            <liNcnt>0</liNcnt>
            <liCper>0</liCper>
          </W2Corte_ReporteParaCortesSIG>
        </soap:Body>
      </soap:Envelope>'''
        : '''<?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Body>
          <W0Corte_ObtenerRutas xmlns="http://activebs.net/">
            <liCper>$liCper</liCper>
          </W0Corte_ObtenerRutas>
        </soap:Body>
      </soap:Envelope>''';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": isImport
              ? "http://activebs.net/W2Corte_ReporteParaCortesSIG"
              : "http://activebs.net/W0Corte_ObtenerRutas",
        },
        body: soapEnvelope,
      );

      if (response.statusCode == 200) {
        _parseSoapResponse(response.body, isImport: isImport);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al enviar datos: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al conectar con el servidor.")),
      );
    }
  }

  void _parseSoapResponse(String response, {required bool isImport}) {
    final startTag = "<diffgr:diffgram";
    final endTag = "</diffgr:diffgram>";

    if (!response.contains(startTag) || !response.contains(endTag)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se encontraron datos válidos en la respuesta.")),
      );
      return;
    }

    final rawXml = response.substring(
      response.indexOf(startTag),
      response.indexOf(endTag) + endTag.length,
    );

    try {
      final document = XmlDocument.parse(rawXml);
      final tables = document.findAllElements('Table');
      List<Map<String, String>> parsedData = [];

      for (var table in tables) {
        if (isImport) {
          // Extrae datos específicos para el botón "Importar Corte"
          parsedData.add({
            "Latitud": table.getElement('bscntlati')?.text ?? "N/A",
            "Longitud": table.getElement('bscntlogi')?.text ?? "N/A",
            "C.U": table.getElement('bscntCodf')?.text ?? "N/A",
            "C.F": table.getElement('bscocNcoc')?.text ?? "N/A",
          });
        } else {
          // Extrae datos específicos para "Cargar Rutas"
          parsedData.add({
            "Ruta": table.getElement('bsrutdesc')?.text ?? "N/A",
          });
        }
      }

      setState(() {
        _tablesData = parsedData;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Datos cargados correctamente.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al procesar datos del servidor.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Importar Cortes"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            SizedBox(height: 20),
            TextField(
              controller: _codigoFijoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Código Ruta",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _sendData(isImport: true),
                  child: Text("Importar Corte"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _tablesData.length,
                itemBuilder: (context, index) {
                  final table = _tablesData[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: table.entries.map((entry) {
                          return Text("${entry.key}: ${entry.value}");
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
     ),
  );
  }
}