import 'package:flutter/material.dart';
import 'package:movil_system_si2/pages/corte.dart';
import '../Services/asistenciaallService.dart';
import '../components/appBar.dart';
import '../components/barMenu.dart';

class AsistenciasPage extends StatefulWidget {
  @override
  _AsistenciasPageState createState() => _AsistenciasPageState();
}

class _AsistenciasPageState extends State<AsistenciasPage> {
  // Lista de rutas para el desplegable
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Opciones de Cortes"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botón "Importar cortes desde el servidor"
            ElevatedButton(
              onPressed: () {
                // Navegar a la sección de "Importar cortes" dentro de AsistenciasPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CortesPage(),
                  ),
                );
              },
              child: Text("Importar cortes desde el servidor"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
              ),
            ),
            SizedBox(height: 10),
            // Botón "Registrar Cortes"
            ElevatedButton(
              onPressed: () {
                // Lógica para registrar cortes
              },
              child: Text("Registrar Cortes"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
              ),
            ),
            SizedBox(height: 10),
            // Botón "Exportar cortes al servidor"
            ElevatedButton(
              onPressed: () {
                // Lógica para exportar cortes al servidor
              },
              child: Text("Exportar cortes al servidor"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
              ),
            ),
            SizedBox(height: 10),
            // Botón "Lista de cortes realizados"
            ElevatedButton(
              onPressed: () {
                // Lógica para mostrar la lista de cortes realizados
              },
              child: Text("Lista de cortes realizados"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
              ),
            ),
            SizedBox(height: 10),
            // Botón "Salir"
            ElevatedButton(
              onPressed: () {
                // Lógica para salir de la aplicación
              },
              child: Text("Salir"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
              ),
            ),
          ],
        ),
     ),
   );
  }
}