import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mohamed_amine_benkhoud_heavyfreight_flutter_test/features/tracking/presentation/screens/tracking_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class DeliveryInfoScreen extends ConsumerStatefulWidget {
  final String pickupLocation;
  final String dropoffLocation;
  final String size;
  final String deliveryType;

  const DeliveryInfoScreen({
    Key? key,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.size,
    required this.deliveryType,
  }) : super(key: key);

  @override
  ConsumerState<DeliveryInfoScreen> createState() => _DeliveryInfoScreenState();
}

class _DeliveryInfoScreenState extends ConsumerState<DeliveryInfoScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController senderNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  bool isRecipient = false;

  // Dark map style JSON (unchanged)
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

  @override
  Widget build(BuildContext context) {
    final mapWidth = MediaQuery.of(context).size.width * 0.9;
    return Scaffold(
      body: Container(
        color: Colors.white, // White background for the entire screen
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Delivery Info',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              const Column(
                                children: [
                                  Text(
                                    'HeavyFreight',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'TRANSPORTATIONS',
                                    style: TextStyle(
                                      fontSize: 7,
                                      color: AppColors.primaryOrange,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: mapWidth,
                        height:
                            mapWidth, // Square map with same width as height
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // Added border radius
                          border: Border.all(
                            color: Colors.grey[400]!,
                          ), // Optional: subtle border
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // Clip map to match container radius
                          child: GoogleMap(
                            initialCameraPosition: const CameraPosition(
                              target: LatLng(33.878147, 10.092575),
                              zoom: 12.0,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('pickup-location'),
                                position: LatLng(33.878147, 10.092575),
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueOrange,
                                ),
                              ),
                            },
                            onMapCreated: (controller) async {
                              controller.setMapStyle(_darkMapStyle);
                            },
                            zoomControlsEnabled: false,
                            mapType: MapType.normal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Search location...',
                            filled: true,
                            fillColor:
                                AppColors.lightGrey, // Light grey background
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 10,
                            ),
                            suffixIcon: const Icon(
                              Icons.search,
                            ), // Added search icon on the right
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: SizedBox(
                        width:
                            MediaQuery.of(context).size.width *
                            0.8, // Divider width set to 80%
                        child: const Divider(color: Colors.grey, thickness: 1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Add me as recipient',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                                Switch(
                                  value: isRecipient,
                                  onChanged: (value) {
                                    setState(() {
                                      isRecipient = value;
                                    });
                                  },
                                  activeColor: AppColors.greenPistro,
                                  activeTrackColor: Colors.white,
                                  inactiveThumbColor: Colors.grey,
                                  inactiveTrackColor: Colors.grey[300],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: addressController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an address';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Address',
                                filled: true,
                                fillColor:
                                    AppColors
                                        .lightGrey, // Light grey background
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 10,
                                ),
                                prefixIcon: const Icon(Icons.location_on),
                              ),
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: senderNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter sender name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Sender Name',
                                filled: true,
                                fillColor:
                                    AppColors
                                        .lightGrey, // Light grey background
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 10,
                                ),
                                prefixIcon: const Icon(Icons.person),
                              ),
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: phoneNumberController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter phone number';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Phone Number',
                                filled: true,
                                fillColor:
                                    AppColors
                                        .lightGrey, // Light grey background
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 10,
                                ),
                                prefixIcon: const Icon(Icons.phone),
                              ),
                              style: const TextStyle(fontSize: 14),
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: CustomButton(
                                text: 'Confirm',
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TrackingScreen(),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please fill all fields.',
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
