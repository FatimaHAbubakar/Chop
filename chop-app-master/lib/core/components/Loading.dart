import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget loading(context) => Scaffold(body: loadingWidget(context));

Widget loadingWidget(context) => SizedBox(
    height: MediaQuery.of(context).size.height - 156,
    child: const Center(child: SpinKitRing(color: Color(0xFFFA5F1A))));
