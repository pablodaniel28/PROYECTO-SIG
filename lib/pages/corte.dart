import 'package:flutter/material.dart';
import '../Services/asistenciaallService.dart';
import '../components/appBar.dart';
import '../components/barMenu.dart';

class CortesPage extends StatefulWidget {
  @override
  _CortesPageState createState() => _CortesPageState();
}



class _CortesPageState extends State<CortesPage> {
  // Lista de rutas para el desplegable  
  String? _selectedRoute = "TODAS LAS RUTAS";
  List<String> _routes = [
    "TODAS LAS RUTAS",
    "Ruta 1",
    "Ruta 2",
    "Ruta 3",
  ];

  // Lista de cortes (simulada)
  List<Map<String, String>> _cuts = [
    {"nombre": "BARTELEMI YOYO CARMEN", "codigo": "40002", "latitud": "-16.383830000", "longitud": "-60.9543900000"},
    {"nombre": "PARA MERCADO MILTON", "codigo": "60008", "latitud": "-16.379650000", "longitud": "-60.9775500000"},
    {"nombre": "LOPEZ AYALA CARMEN EDITH", "codigo": "65002", "latitud": "-16.383940000", "longitud": "-60.9544400000"},
    {"nombre": "DORADO RIVERO DALMIRO", "codigo": "110001", "latitud": "0.000000000", "longitud": "0.0000000000"},
    {"nombre": "VALERIANO CHURA PABLO", "codigo": "140003", "latitud": "0.000000000", "longitud": "0.0000000000"},
    {"nombre": "PICO LABERAN ADELIA MAIELA", "codigo": "160001", "latitud": "0.000000000", "longitud": "0.0000000000"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cortes"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DropdownButton (Menú de rutas)
            DropdownButton<String>(
              value: _selectedRoute,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRoute = newValue;
                });
              },
              items: _routes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            
            // Lista de cortes
            Expanded(
              child: ListView.builder(
                itemCount: _cuts.length,
                itemBuilder: (context, index) {
                  var cut = _cuts[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    color: Colors.yellow[100],
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cut['nombre']!, style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text("C.U.: ${cut['codigo']} C.F.: ${cut['codigo']}"),
                          Text("Latitud: ${cut['latitud']} Longitud: ${cut['longitud']}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Botones debajo de la lista
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción para "Importar cortes"
              },
              child: Text("Importar cortes"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Acción para "Grabar cortes"
              },
              child: Text("Grabar cortes"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Acción para "Volver al menú"
              },
              child: Text("Volver al menú"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
            ),
          ],
        ),
     ),
   );
  }
}