import 'package:chop/domain/model/user.dart';
import 'package:chop/presentation/pages/fii_home_page/fii_home_page.dart';
import 'package:chop/presentation/pages/fii_rescue_page/fii_rescue_page.dart';
import 'package:chop/presentation/pages/profile_pages/profile_page_fii.dart';
import 'package:chop/presentation/pages/profile_pages/profile_page_vendor.dart';
import 'package:chop/presentation/pages/vendor_inventory_page/vendor_inventory_page.dart';
import 'package:chop/presentation/pages/vendor_rescue_page/vendor_rescue_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MainPage extends HookWidget {
  final User user;
  final Duration preventTapDuration;

  const MainPage(this.user,
      {super.key, this.preventTapDuration = const Duration(seconds: 1)});

  @override
  Widget build(BuildContext context) {
    final navBarIndex = useState(0);
    final lastTapTime = useRef(DateTime.now());

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 100,
              color: const Color(0xFFFA5F1A),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      const Expanded(child: SizedBox()),
                      Image.asset(
                        'assets/images/logo.png',
                        height: 50, // Adjust the height as needed
                      ),
                    ],
                  ),
                ),
              ),
            ),
            MainPageWidget(navBarIndex: navBarIndex, user: user),
            Container(
              height: 56,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                selectedItemColor: const Color(0xFFFA5F1A),
                unselectedItemColor: Colors.grey,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                currentIndex: navBarIndex.value,
                onTap: (value) async {
                  final now = DateTime.now();
                  if (now.difference(lastTapTime.value) >= preventTapDuration) {
                    lastTapTime.value = now;
                    navBarIndex.value = value;
                  }
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.security),
                    label: 'Ticket',
                  ),
                  // if (user.role == 'FII')
                  //   const BottomNavigationBarItem(
                  //     icon: Icon(Icons.notifications),
                  //     label: 'Notifications',
                  //   ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainPageWidget extends StatelessWidget {
  final ValueNotifier<int> navBarIndex;
  final User user;

  const MainPageWidget(
      {super.key, required this.navBarIndex, required this.user});

  @override
  Widget build(BuildContext context) {
    if (user.role == "VENDOR") {
      switch (navBarIndex.value) {
        case 0:
          return const VendorInventoryPage();
        case 1:
          return const VendorRescuePage();
        case 2:
          return ProfilePageVendor(vendor: user);
      }
    }
    if (user.role == "FII") {
      switch (navBarIndex.value) {
        case 0:
          return const FIIHomePage();
        case 1:
          return const FIIRescuePage();
        case 2:
          return ProfilePageFII(fii: user);
      }
    }

    return const Expanded(
      child: SpinKitChasingDots(
        color: Color(0xFFFA5F1A),
      ),
    );
  }
}
