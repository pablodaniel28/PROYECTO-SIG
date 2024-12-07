import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class RegistrarCortesScreen extends StatefulWidget {
  @override
  _RegistrarCortesScreenState createState() => _RegistrarCortesScreenState();
}

class _RegistrarCortesScreenState extends State<RegistrarCortesScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  static const LatLng _initialPosition = LatLng(-17.7833, -63.1821); // Santa Cruz, Bolivia
  final List<LatLng> _houseLocations = [
    LatLng(-17.7833, -63.1821), // Ubicación 1
    LatLng(-17.7900, -63.1800), // Ubicación 2
    LatLng(-17.7750, -63.1900), // Ubicación 3
  ];

  LatLng? _currentLocation;
  final String googleMapsApiKey = 'AIzaSyCPIyRlEFGVIpKQKqr-11flIS16F8EsgJc'; // Reemplaza con tu API Key

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      _requestLocationPermission();
    }
    _getCurrentLocation();
    _addHouseMarkers();
  }

  // Inicializar el controlador del mapa
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {});
  }

  // Solicitar permisos de ubicación
  Future<void> _requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else {
      // Maneja el caso cuando el permiso es denegado
    }
  }

  // Obtener la ubicación actual del usuario
  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    _drawRoute();
  }

  // Agregar marcadores de las casas
  void _addHouseMarkers() {
    _houseLocations.forEach((location) {
      _markers.add(Marker(
        markerId: MarkerId(location.toString()),
        position: location,
        infoWindow: InfoWindow(title: 'Casa'),
      ));
    });
    setState(() {});
  }

  // Dibujar las rutas de la ubicación actual a cada casa
  void _drawRoute() {
    if (_currentLocation == null) return;

    List<LatLng> allRoutePoints = [_currentLocation!];

    // Conectar las casas secuencialmente
    for (int i = 0; i < _houseLocations.length; i++) {
      allRoutePoints.add(_houseLocations[i]);

      // Dibujar una polilínea entre la ubicación actual y la primera casa,
      // luego entre las casas secuencialmente
      _polylines.add(Polyline(
        polylineId: PolylineId('route_$i'),
        points: i == 0
            ? [_currentLocation!, _houseLocations[i]] // Primero de la ubicación actual a la casa 1
            : [_houseLocations[i - 1], _houseLocations[i]], // Conectar casas entre sí
        color: Colors.blue,
        width: 5,
      ));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ruta a Cortes")),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 14),
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
