import 'package:chop/presentation/pages/checkout_page/checkout_page.dart';
import 'package:chop/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:latlong2/latlong.dart';

import 'package:chop/presentation/pages/map_page.dart';

import '../../domain/model/rescue.dart';
import '../../domain/model/user.dart';

class RescueSuccessPage extends StatelessWidget {
  final Rescue rescue;
  final User vendor;
  final User fii;

  const RescueSuccessPage(
      {Key? key, required this.rescue, required this.vendor, required this.fii})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LatLng? latLong = getLatAndLong(vendor.location);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Rescue saved successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 40,
                      fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: QrImage(data: rescue.code),
            ),
            OrangeIconButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MainPage(fii)),
                    (route) => false),
                icon: Icons.home_outlined,
                text: 'Home Page'),
            const SizedBox(height: 20),
            if (latLong != null)
              OrangeIconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MapPage(
                        location: latLong,
                      ),
                    ),
                  );
                },
                icon: Icons.pin_drop_outlined,
                text: 'Get directions',
              ),
          ]),
        ),
      ),
    );
  }

  LatLng? getLatAndLong(String? location) {
    if (location == null) return null;

    final pattern = RegExp(r'(\d+\.\d+),(\d+\.\d+)');
    final match = pattern.firstMatch(location);

    if (match == null) return null;

    final latitude = double.parse(match.group(1)!);
    final longitude = double.parse(match.group(2)!);

    return LatLng(latitude, longitude);
  }
}
