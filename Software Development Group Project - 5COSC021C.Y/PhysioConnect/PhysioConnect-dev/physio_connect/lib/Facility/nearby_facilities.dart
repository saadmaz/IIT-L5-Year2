// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NearbyFacilitiesScreen extends StatefulWidget {
  const NearbyFacilitiesScreen({super.key});

  @override
  _NearbyFacilitiesScreenState createState() => _NearbyFacilitiesScreenState();
}

class _NearbyFacilitiesScreenState extends State<NearbyFacilitiesScreen>
    with SingleTickerProviderStateMixin {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  late TabController _tabController;
  bool _isLoading = true;

  final Set<Marker> _hospitalMarkers = {};
  final Set<Marker> _doctorMarkers = {};
  final Set<Marker> _physiotherapistMarkers = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    _getUserLocation();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0:
            _markers.clear();
            _markers.addAll(_hospitalMarkers);
            break;
          case 1:
            _markers.clear();
            _markers.addAll(_doctorMarkers);
            break;
          case 2:
            _markers.clear();
            _markers.addAll(_physiotherapistMarkers);
            break;
        }
      });
    }
  }

  Future<void> _getUserLocation() async {
    setState(() => _isLoading = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLoading = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        setState(() => _isLoading = false);
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ),
      );
    });

    // Clear old markers
    _hospitalMarkers.clear();
    _doctorMarkers.clear();
    _physiotherapistMarkers.clear();

    // Fetch markers
    await Future.wait([
      _fetchNearbyFacilities(
        position.latitude,
        position.longitude,
        "hospital",
        _hospitalMarkers,
      ),
      _fetchNearbyFacilities(
        position.latitude,
        position.longitude,
        "doctor",
        _doctorMarkers,
      ),
      _fetchNearbyFacilities(
        position.latitude,
        position.longitude,
        "physiotherapist",
        _physiotherapistMarkers,
      ),
    ]);

    setState(() {
      _markers.addAll(_hospitalMarkers);
      _isLoading = false;
    });
  }

  Future<void> _fetchNearbyFacilities(
      double lat,
      double lng,
      String type,
      Set<Marker> markerSet,
      ) async {
    const apiKey = "AIzaSyAUiLi358QxvTGF8oKIkZ43kcHMsiTQ2YE";
    const radius = 49000; // 49 km

    String nextPageToken = '';
    int pageCount = 0;

    do {
      final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=$radius&type=$type&key=$apiKey${nextPageToken.isNotEmpty ? '&pagetoken=$nextPageToken' : ''}",
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> places = data["results"];

        setState(() {
          for (var place in places) {
            final marker = Marker(
              markerId: MarkerId(place["place_id"]),
              position: LatLng(
                place["geometry"]["location"]["lat"],
                place["geometry"]["location"]["lng"],
              ),
              infoWindow: InfoWindow(
                title: place["name"],
                snippet: place["vicinity"],
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                type == "hospital"
                    ? BitmapDescriptor.hueRed
                    : type == "doctor"
                    ? BitmapDescriptor.hueBlue
                    : BitmapDescriptor.hueGreen,
              ),
            );
            markerSet.add(marker);
          }
        });

        nextPageToken = data["next_page_token"] ?? '';
        if (nextPageToken.isNotEmpty) {
          pageCount++;
          await Future.delayed(const Duration(seconds: 2));
        }
      } else {
        break;
      }
    } while (nextPageToken.isNotEmpty && pageCount < 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF33724B),
        title: const Text("Nearby Facilities Locator"),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(
              icon: Icon(Icons.local_hospital, color: Colors.white),
              child: Text(
                "Hospitals",
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
            ),
            Tab(
              icon: Icon(Icons.medical_services, color: Colors.white),
              child: Text(
                "Doctors",
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
            ),
            Tab(
              icon: Icon(Icons.healing, color: Colors.white),
              child: Text(
                "Physiotherapists",
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
      body: _isLoading || _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
              ),
              zoom: 13,
            ),
            myLocationEnabled: true,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Text(
                _tabController.index == 0
                    ? "Showing nearby hospitals (within 49km)"
                    : _tabController.index == 1
                    ? "Showing nearby doctors (within 49km)"
                    : "Showing nearby physiotherapists (within 49km)",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
