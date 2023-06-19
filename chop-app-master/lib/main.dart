// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:chop/core/components/loading.dart';
import 'package:chop/domain/model/user.dart';
import 'package:chop/presentation/pages/login_page/login_page.dart';
import 'package:chop/presentation/pages/main_page.dart';
import 'package:chop/presentation/pages/signup_page/signup_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  await Hive.openBox('chopBox');
  runApp(const ChopApp());
}

class RequestLocationPage extends StatelessWidget {
  final User? user;

  const RequestLocationPage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text(
              'Chop requires your location in order to work. Please allow location services for Chop in your device.',
            ),
            TextButton(
                onPressed: () async {
                  bool locationGranted = await requestLocationPermission();
                  if (locationGranted) {
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (context) {
                        return user == null
                            ? const LoginPage()
                            : MainPage(user!);
                      },
                    ), (route) => false);
                  }
                },
                child: const Text(
                  'Request location permission',
                  style: TextStyle(color: Color(0xFFFA5F1A)),
                ))
          ],
        ),
      ),
    );
  }
}

class ChopApp extends StatelessWidget {
  const ChopApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? user;

    try {
      String? userString = sl<SharedPreferences>().getString('user');
      user = userString == null ? null : User.fromJson(jsonDecode(userString));
    } on Exception {
      SystemNavigator.pop();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chop',
      theme: ThemeData(
          textTheme: GoogleFonts.inriaSansTextTheme(),
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFFFA5F1A),
            onPrimary: Color.fromARGB(255, 165, 62, 18),
            secondary: Color(0xFF252525),
            onSecondary: Color.fromARGB(255, 102, 94, 94),
            error: Color.fromARGB(255, 255, 53, 53),
            onError: Color.fromARGB(255, 153, 33, 33),
            background: Colors.white,
            onBackground: Color(0xFF252525),
            surface: Colors.white,
            onSurface: Color(0xFF252525),
          )),
      home: FutureBuilder<bool>(
          future: requestLocationPermission(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                return user == null ? const LoginPage() : MainPage(user);
              } else {
                return RequestLocationPage(user: user);
              }
            } else {
              return loading(context);
            }
          }),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => const LoginPage(),
        '/signup': (BuildContext context) => const SignUpPage(),
      },
    );
  }
}

Future<bool> requestLocationPermission() async {
  if (await Permission.location.isGranted) {
    return true;
  } else {
    var status = await Permission.location.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}
