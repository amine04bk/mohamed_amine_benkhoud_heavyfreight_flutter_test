import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:heavyfreight_app/features/delivery_info/presentation/screens/delivery_info_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../models/package.dart';
import '../providers/package_form_provider.dart';

class PackageFormScreen extends ConsumerStatefulWidget {
  const PackageFormScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PackageFormScreen> createState() => _PackageFormScreenState();
}

class _PackageFormScreenState extends ConsumerState<PackageFormScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController fromController = TextEditingController(
    text: 'Gabes 6011, Cité zouhour',
  );
  final TextEditingController toController = TextEditingController(
    text: 'Tunis 4021, Cité olympique',
  );

  @override
  Widget build(BuildContext context) {
    final selectedSize = ref.watch(selectedPackageSizeProvider);
    final selectedDelivery = ref.watch(selectedDeliveryTypeProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset('assets/mainbg.jpg', fit: BoxFit.cover),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                              'New Delivery',
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
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Left Column: Indicators
                            Column(
                              children: List.generate(5, (index) {
                                final isFirst = index == 0;
                                final isLast = index == 4;
                                return Container(
                                  width: 10,
                                  height: 10,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 11,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isFirst
                                            ? AppColors.greenIndicator
                                            : isLast
                                            ? Colors.yellow
                                            : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(width: 16),
                            // Middle Column: From/To Fields
                            Expanded(
                              flex: 5,
                              child: Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // FROM section
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'From',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.9,
                                      child: TextFormField(
                                        controller: fromController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a pickup location';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Enter pickup location',
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal: 10,
                                              ),
                                          suffixIcon: IconButton(
                                            icon: const Icon(
                                              Icons.map,
                                              color: AppColors.primaryOrange,
                                            ),
                                            onPressed: () async {
                                              final address =
                                                  await _showMapPicker(
                                                    context,
                                                    ref,
                                                    fromController,
                                                  );
                                              if (address != null) {
                                                fromController.text = address;
                                                formKey.currentState!
                                                    .validate();
                                              }
                                            },
                                          ),
                                        ),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 0.5,
                                    ),
                                    // TO section
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'To',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.9,
                                      child: TextFormField(
                                        controller: toController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a dropoff location';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Enter dropoff location',
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal: 10,
                                              ),
                                          suffixIcon: IconButton(
                                            icon: const Icon(
                                              Icons.map,
                                              color: AppColors.primaryOrange,
                                            ),
                                            onPressed: () async {
                                              final address =
                                                  await _showMapPicker(
                                                    context,
                                                    ref,
                                                    toController,
                                                  );
                                              if (address != null) {
                                                toController.text = address;
                                                formKey.currentState!
                                                    .validate();
                                              }
                                            },
                                          ),
                                        ),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Text(
                            'Package Size',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildPackageSizeOption(
                                ref,
                                'small',
                                '< 5 kg',
                                'assets/small.png',
                              ),
                              _buildPackageSizeOption(
                                ref,
                                'medium',
                                '5 - 20 kg',
                                'assets/medium.png',
                              ),
                              _buildPackageSizeOption(
                                ref,
                                'large',
                                '> 20 kg',
                                'assets/large.png',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Text(
                            'Delivery Packs',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildDeliveryPackOption(
                            ref,
                            'Standard',
                            '2-3 Days shipping',
                            '23 DT',
                            'standard',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildDeliveryPackOption(
                            ref,
                            'Fast',
                            '1 Day shipping',
                            '32 DT',
                            'fast',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CustomButton(
                            text: 'Continue',
                            onPressed: () {
                              if (formKey.currentState!.validate() &&
                                  selectedSize != null &&
                                  selectedSize.isNotEmpty &&
                                  selectedDelivery != null &&
                                  selectedDelivery.isNotEmpty) {
                                final package = Package(
                                  pickupLocation: fromController.text,
                                  dropoffLocation: toController.text,
                                  size: selectedSize,
                                  deliveryType: selectedDelivery,
                                );
                                ref
                                    .read(packageFormProvider.notifier)
                                    .setPackage(package);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => DeliveryInfoScreen(
                                          pickupLocation: fromController.text,
                                          dropoffLocation: toController.text,
                                          size: selectedSize,
                                          deliveryType: selectedDelivery,
                                        ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please fill all fields and select a package size and delivery type.',
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _showMapPicker(
    BuildContext context,
    WidgetRef ref,
    TextEditingController controller,
  ) async {
    LatLng? selectedPosition;
    final Completer<GoogleMapController> mapController = Completer();
    final Set<Marker> markers = {};

    try {
      return showDialog<String>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Select Location'),
              content: SizedBox(
                width: 300,
                height: 400,
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(
                              33.8869,
                              9.7916,
                            ), // Default to Tunisia
                            zoom: 7.0,
                          ),
                          onMapCreated:
                              (controller) =>
                                  mapController.complete(controller),
                          onTap: (position) async {
                            setState(() {
                              selectedPosition = position;
                              markers.clear(); // Clear previous markers
                              markers.add(
                                Marker(
                                  markerId: const MarkerId('selected-location'),
                                  position: selectedPosition!,
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueOrange,
                                  ), // Orange marker
                                ),
                              );
                            });
                            // Move camera to the tapped location for better feedback
                            final GoogleMapController controller =
                                await mapController.future;
                            controller.animateCamera(
                              CameraUpdate.newLatLng(selectedPosition!),
                            );
                          },
                          markers: markers, // Use the dynamic markers set
                        ),
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (selectedPosition != null) {
                                  List<Placemark> placemarks =
                                      await placemarkFromCoordinates(
                                        selectedPosition!.latitude,
                                        selectedPosition!.longitude,
                                      );
                                  if (placemarks.isNotEmpty) {
                                    final placemark = placemarks.first;
                                    final address =
                                        '${placemark.street}, ${placemark.locality}, ${placemark.country}';
                                    Navigator.pop(context, address);
                                  }
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text('Confirm Location'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
      );
    } catch (e) {
      print('Error in _showMapPicker: $e');
      return null;
    }
  }

  Widget _buildPackageSizeOption(
    WidgetRef ref,
    String label,
    String weight,
    String imagePath,
  ) {
    final selected = ref.watch(selectedPackageSizeProvider) == label;
    final notifier = ref.read(selectedPackageSizeProvider.notifier);

    return GestureDetector(
      onTap: () {
        if (selected) {
          notifier.state = null;
        } else {
          notifier.state = label;
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: selected ? AppColors.primaryOrange : AppColors.lightGrey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(weight),
                const SizedBox(height: 5),
                Image.asset(imagePath, width: 40, height: 40),
                const SizedBox(height: 5),
                Text(label, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          if (selected)
            Positioned(
              top: -10,
              right: -10,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: selected ? 1.0 : 0.0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.check, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDeliveryPackOption(
    WidgetRef ref,
    String title,
    String subtitle,
    String price,
    String type,
  ) {
    final selected = ref.watch(selectedDeliveryTypeProvider) == type;
    final notifier = ref.read(selectedDeliveryTypeProvider.notifier);

    return GestureDetector(
      onTap: () {
        if (selected) {
          notifier.state = '';
        } else {
          notifier.state = type;
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: selected ? AppColors.primaryOrange : AppColors.lightGrey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(subtitle, style: const TextStyle(fontSize: 12)),
                  ],
                ),
                Text(
                  price,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          if (selected)
            Positioned(
              top: -10,
              right: -10,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: selected ? 1.0 : 0.0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.check, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
