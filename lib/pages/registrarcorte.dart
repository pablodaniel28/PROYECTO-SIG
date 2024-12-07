import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io'; // Para Platform.isAndroid

class RegistrarCortesScreen extends StatefulWidget {
  @override
  _RegistrarCortesScreenState createState() => _RegistrarCortesScreenState();
}

class _RegistrarCortesScreenState extends State<RegistrarCortesScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();

  // Coordenadas iniciales del mapa
  static const LatLng _initialPosition = LatLng(-17.7833, -63.1821); // Santa Cruz, Bolivia
  late GoogleMapController _mapController;

  // Lista de marcadores (ubicaciones de las casas)
  final Set<Marker> _markers = {};

  // Aquí puedes agregar las ubicaciones de las casas con latitudes y longitudes específicas
  final List<LatLng> _houseLocations = [
    LatLng(-17.7833, -63.1821),  // Ubicación 1 (Santa Cruz)
    LatLng(-17.7900, -63.1800),  // Ubicación 2
    LatLng(-17.7750, -63.1900),  // Ubicación 3
  ];

  @override
  void initState() {
    super.initState();
    
    // Solicitar permisos de ubicación en Android
    if (Platform.isAndroid) {
      _requestLocationPermission();
    }

    // Crear los marcadores
    for (var location in _houseLocations) {
      _markers.add(
        Marker(
          markerId: MarkerId(location.toString()),
          position: location,
          infoWindow: InfoWindow(title: 'Casa'),
        ),
      );
    }
  }

  Future<void> _requestLocationPermission() async {
    // Solicita el permiso de ubicación
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      print("Ubicación permitida");
    } else {
      print("Ubicación no permitida");
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _montoController.dispose();
    _fechaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Cortes"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Mapa de Google
          Expanded(
            flex: 2,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              markers: _markers,
            ),
          ),
        ],
      ),
    );
  }
}
