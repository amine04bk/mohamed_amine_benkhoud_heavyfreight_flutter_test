import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_colors.dart';
import '../providers/tracking_provider.dart';
import '../../../../models/tracking_data.dart';

class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    const LatLng citeZouhour = LatLng(33.878147, 10.092575);
    const LatLng avOmarIbnElKhattab = LatLng(33.883517, 10.101015);

    _markers.addAll([
      Marker(
        markerId: const MarkerId('cite_zouhour'),
        position: citeZouhour,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
      Marker(
        markerId: const MarkerId('av_omar'),
        position: avOmarIbnElKhattab,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
    ]);

    final polylinePoints = await _getRoutePolyline(
      citeZouhour,
      avOmarIbnElKhattab,
    );
    setState(() {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: polylinePoints,
          color: AppColors.primaryOrange,
          width: 6,
        ),
      );
    });

    // Adjust camera to fit the route
    final GoogleMapController controller = await _mapController.future;
    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        citeZouhour.latitude < avOmarIbnElKhattab.latitude
            ? citeZouhour.latitude
            : avOmarIbnElKhattab.latitude,
        citeZouhour.longitude < avOmarIbnElKhattab.longitude
            ? citeZouhour.longitude
            : avOmarIbnElKhattab.longitude,
      ),
      northeast: LatLng(
        citeZouhour.latitude > avOmarIbnElKhattab.latitude
            ? citeZouhour.latitude
            : avOmarIbnElKhattab.latitude,
        citeZouhour.longitude > avOmarIbnElKhattab.longitude
            ? citeZouhour.longitude
            : avOmarIbnElKhattab.longitude,
      ),
    );
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  Future<List<LatLng>> _getRoutePolyline(LatLng start, LatLng end) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? ''; // Load from .env
    if (apiKey.isEmpty) {
      debugPrint('Error: GOOGLE_MAPS_API_KEY not found in .env file');
      return [];
    }
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        final encodedPolyline =
            data['routes'][0]['overview_polyline']['points'];
        return _decodePolyline(encodedPolyline);
      } else {
        debugPrint(
          'No route found: ${data['error_message'] ?? 'Unknown error'}',
        );
        return [start, end]; // Fallback to straight line
      }
    } else {
      debugPrint(
        'Failed to fetch routes: ${response.statusCode} - ${response.body}',
      );
      return [start, end]; // Fallback to straight line
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }

  @override
  Widget build(BuildContext context) {
    final trackingState = ref.watch(trackingProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 10),
            const Text(
              'Tracking Delivery',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const Column(
              children: [
                SizedBox(height: 30),
                Text(
                  'HeavyFreight',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                Text(
                  'TRANSPORTATIONS',
                  style: TextStyle(fontSize: 7, color: AppColors.primaryOrange),
                ),
              ],
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
      body: trackingState.when(
        data: (data) => _buildTrackingContent(context, data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildTrackingContent(BuildContext context, TrackingData data) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Order ID : ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    '${data.orderId}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 200,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(33.8685, 10.0982),
                zoom: 13.0,
              ),
              onMapCreated: (controller) async {
                _mapController.complete(controller);
                controller.setMapStyle(_darkMapStyle);
              },
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column 1
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: AppColors.greenPistro, // Pistachio green
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.timer,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.eta),
                            const SizedBox(height: 4),
                            Text("Delivery time"),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: AppColors.greenPistro, // Pistachio green
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.pickupLocation),
                            const SizedBox(height: 4),
                            const Text('Your Address'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 60),
              // Column 2
              Expanded(
                flex: 1,
                child: Container(
                  height: 150,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/small.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${data.weight.toStringAsFixed(1)} kg',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Weight',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Image.asset(
                    'assets/image.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.driverName),
                    const Text(
                      'Your courier',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.message,
                    color: AppColors.primaryOrange,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  } // Dark map style JSON

  final String _darkMapStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#212121"
        }
      ]
    },
    {
      "elementType": "labels.icon",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#212121"
        }
      ]
    },
    {
      "featureType": "administrative",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "featureType": "administrative.country",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#9e9e9e"
        }
      ]
    },
    {
      "featureType": "administrative.land_parcel",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "administrative.locality",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#bdbdbd"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#181818"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#616161"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#1b1b1b"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#2c2c2c"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#8a8a8a"
        }
      ]
    },
    {
      "featureType": "road.arterial",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#373737"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#3c3c3c"
        }
      ]
    },
    {
      "featureType": "road.highway.controlled_access",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#4e4e4e"
        }
      ]
    },
    {
      "featureType": "road.local",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#616161"
        }
      ]
    },
    {
      "featureType": "transit",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#000000"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#3d3d3d"
        }
      ]
    }
  ]
  ''';
}
