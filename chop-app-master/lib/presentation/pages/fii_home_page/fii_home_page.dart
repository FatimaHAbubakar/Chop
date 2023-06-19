import 'package:chop/core/components/loading.dart';
import 'package:chop/core/mixins/mixins.dart';
import 'package:chop/core/use_case/use_case.dart';
import 'package:chop/di.dart';
import 'package:chop/domain/model/review.dart';
import 'package:chop/domain/model/user.dart';
import 'package:chop/presentation/pages/fii_home_page/cubit/fii_home_page_cubit.dart';
import 'package:chop/presentation/pages/vendor_detail_page/vendor_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class FIIHomePage extends HookWidget with ErrorDialog {
  const FIIHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shownVendors = useState<List<User>>([]);
    final firstRun = useState(true);
    final toRemove = useState<List<User>>([]);
    final denied = useState(false);
    // requestLocationPermission();
    if (denied.value) {
      requestLocationPermission(denied);
      denied.value = true;
    }
    return BlocProvider(
      create: (context) =>
          sl<FIIHomePageCubit>()..getVendorsAndReviews(NoParams()),
      child: BlocConsumer<FIIHomePageCubit, FIIHomePageState>(
        listener: (context, state) {
          if (state is FIIHomePageSignOut) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/login', (route) => false);
          } else if (state is FIIHomePageError) {
            errorDialog(context, state.errorMessage,
                onPressed: () => Navigator.of(context).pop());
          }
        },
        builder: (context, state) {
          if (state is! FIIHomePageInitial) return loadingWidget(context);

          if (firstRun.value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              shownVendors.value = state.vendors;
              firstRun.value = false;
            });
          }
          shownVendors.value.removeWhere((e) => toRemove.value.contains(e));
          return Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (text) {
                            if (text.isEmpty) {
                              shownVendors.value = state.vendors;
                            } else {
                              shownVendors.value = [];
                              for (var food in state.vendors) {
                                if (food.name
                                    .toLowerCase()
                                    .contains(text.toLowerCase())) {
                                  shownVendors.value.add(food);
                                }
                              }
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: "Search...",
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    itemCount: shownVendors.value.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (BuildContext context, int i) {
                      String? address = shownVendors.value[i].address;

                      Map<double, double>? latAndLong =
                          getLatAndLong(shownVendors.value[i].location);

                      List<Review> vendorReviews = [];
                      vendorReviews.addAll(state.reviews.where(
                          (e) => e.vendorId == shownVendors.value[i].id));
                      double averageRating = getAverageRating(vendorReviews);
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => VendorDetailedPage(
                                    vendor: shownVendors.value[i],
                                    averageRating: averageRating.isNaN
                                        ? null
                                        : averageRating))),
                        child: Card(
                          color: const Color(0xFFF6F0F0),
                          clipBehavior: Clip.antiAlias,
                          child: ListTile(
                            title: Text(shownVendors.value[i].name),
                            subtitle: address == null || latAndLong == null
                                ? const SizedBox()
                                : Row(
                                    children: [
                                      Text('$address | '),
                                      FutureBuilder<double?>(
                                          future: getDistance(
                                              latAndLong.keys.toList()[0],
                                              latAndLong.values.toList()[0],
                                              denied),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                    ConnectionState.done &&
                                                snapshot.data != null &&
                                                !denied.value) {
                                              return Text(
                                                  '${snapshot.data!.toStringAsFixed(1)} km away');
                                            } else {
                                              return const Text('Loading...');
                                            }
                                          })
                                    ],
                                  ),
                            trailing: averageRating.toString() == 'NaN'
                                ? const SizedBox()
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.yellow, size: 20),
                                      const SizedBox(width: 10),
                                      Text(averageRating.toStringAsFixed(1)),
                                    ],
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<double?> getDistance(double lat, double long, denied) async {
    if (await Permission.location.status.isGranted) {
      Position curPos = await Geolocator.getCurrentPosition();
      return Geolocator.distanceBetween(
              lat, long, curPos.latitude, curPos.longitude) /
          1000;
    }
    denied.value = true;
    return null;
  }

  Map<double, double>? getLatAndLong(String? input) {
    if (input == null) return null;
    final pattern = RegExp(r'(\d+\.\d+),(\d+\.\d+)');

    final match = pattern.firstMatch(input);

    if (match == null) return null;

    final firstDouble = double.parse(match.group(1)!);
    final secondDouble = double.parse(match.group(2)!);
    return {firstDouble: secondDouble};
  }

  double getAverageRating(List<Review> reviews) {
    double sum = 0;
    for (var e in reviews) {
      sum += e.star;
    }
    return sum / reviews.length;
  }

  Future<bool> requestLocationPermission(denied) async {
    if (await Permission.location.status.isGranted) {
      denied.value = true;
      denied.value = false;
      return true;
    }
    if (await Permission.location.status.isDenied) {
      var status = await Permission.location.request();
      if (status.isDenied) {
        denied.value = true;
        return false;
      }

      if (await Permission.location.isRestricted) {
        denied.value = true;
        return false;
      }
    }
    denied.value = true;
    return false;
  }
}
