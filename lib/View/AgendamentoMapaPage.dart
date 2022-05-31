import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AgendamentoMapaPage extends StatefulWidget {
  const AgendamentoMapaPage({Key? key}) : super(key: key);

  @override
  State<AgendamentoMapaPage> createState() => _AgendamentoMapaPageState();
}

class _AgendamentoMapaPageState extends State<AgendamentoMapaPage> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _posicaoCamera = CameraPosition(target: LatLng(-30.859936627097856, -51.801529488434994), zoom: 19);
  Set<Marker> _marcadores = {};
  Set<Marker> _marcadoresPostos = {};

  _recuperarLocalizacaoAtual() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _posicaoCamera = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 19);
      _movimentarCamera();
    });
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(_posicaoCamera));
  }

  _carregarMarcadorHospital() {
    Marker marcadorHospital = Marker(
        markerId: MarkerId("Hemocentro"),
        position: LatLng(-30.846130345089524, -51.81487032246458),
        infoWindow: InfoWindow(title: "Hospital"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
    _marcadoresPostos.add(marcadorHospital);

    setState(() {
      _marcadores = _marcadoresPostos;
    });
  }

  _carregarMarcadores(titulo, lat, Long) {
    Marker marcadorPosto = Marker(
        markerId: MarkerId(titulo),
        position: LatLng(lat, Long),
        infoWindow: InfoWindow(title: titulo),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));

    _marcadoresPostos.add(marcadorPosto);
    setState(() {
      _marcadores = _marcadoresPostos;
    });
  }

  @override
  void initState() {
    _recuperarLocalParaEndereco("R. Ana Gonçalves da Silva, 1059 - Getúlio Vargas");
    _recuperarLocalizacaoAtual();
    _carregarMarcadorHospital();
    //_montaMarcacaoHemocentros();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: corpo(context),
      appBar: barraSuperior(),
    );
  }

  barraSuperior() {
    return AppBar(
      title: Text("Tela agendamento de doação"),
      centerTitle: true,
      backgroundColor: Colors.red[400],
    );
  }

  _verificaPermissao() async {
    LocationPermission permission = await Geolocator.requestPermission();
  }

  _recuperarLocalParaEndereco(String endereco) async {
    List<Location> locations = await locationFromAddress(endereco);
    if (locations != null && locations.length > 0) {
      Location endereco = locations[0];

      print("resultado: " + endereco.toString());
    }
  }

  _montaMarcacaoHemocentros() async {
    List<Location> locations = await locationFromAddress("HNSA - Hospital Nossa Senhora Aparecida");
    if (locations != null && locations.length > 0) {
      for (var lista in locations) {
        _carregarMarcadores("Hemocentro", lista.latitude, lista.longitude);
        print(locations.toString());
      }
    }
  }

  _recuperarEnderecoPeloLocal(double lat, double long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
  }

  _onMapCreated(GoogleMapController googleMapController) {
    _verificaPermissao();
    _controller.complete(googleMapController);
  }

  Widget corpo(context) {
    return Container(
      child: GoogleMap(
        mapType: MapType.normal,
        markers: _marcadores,
        initialCameraPosition: CameraPosition(target: LatLng(-30.859936627097856, -51.801529488434994), zoom: 18),
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
      ),
    );
  }
}
