import 'package:chop/core/components/loading.dart';
import 'package:chop/core/mixins/mixins.dart';
import 'package:chop/domain/model/user.dart';
import 'package:chop/presentation/pages/checkout_page/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../di.dart';
import '../../../domain/model/inventory.dart';
import 'cubit/vendor_detail_page_cubit.dart';

class VendorDetailedPage extends HookWidget with ErrorDialog {
  final User vendor;
  final double? averageRating;

  const VendorDetailedPage({Key? key, required this.vendor, this.averageRating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedFoods = useState<Map<String, Map<String, dynamic>>>({});
    final showCart = useState(false);
    final items = useState(0);

    return BlocProvider(
      create: (context) =>
          sl<VendorDetailPageCubit>()..getInventories(vendor.id),
      child: BlocConsumer<VendorDetailPageCubit, VendorDetailPageState>(
        listener: (context, state) {
          if (state is VendorDetailPageSignOut) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/login', (route) => false);
          } else if (state is VendorDetailPageError) {
            errorDialog(context, state.errorMessage,
                onPressed: () => Navigator.of(context).pop());
          }
        },
        builder: (context, state) {
          if (state is! VendorDetailPageInitial) return loading(context);
          List<String> categories = [];
          for (var e in state.foods) {
            if (!categories.contains(e.category)) categories.add(e.category);
          }

          Map<String, List<Inventory>> categoriesFoods = {};

          for (String category in categories) {
            List<Inventory> categoryFoods = [];
            categoryFoods
                .addAll(state.foods.where((food) => category == food.category));
            categoriesFoods.addAll({category: categoryFoods});
          }
          return Scaffold(
            floatingActionButton: showCart.value
                ? GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CheckoutPage(
                            selectedFoods: selectedFoods.value,
                            vendor: vendor))),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30,
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 7,
                                offset: Offset(5, 5))
                          ],
                          color: const Color(0xFFFA5F1A),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const Icon(Icons.shopping_bag_outlined,
                                color: Colors.white),
                            const SizedBox(width: 10),
                            const Text(
                              'View cart',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            const Expanded(child: SizedBox()),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(
                                  items.value.toString(),
                                  style: const TextStyle(
                                      color: Color(0xFFFA5F1A), fontSize: 18),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : null,
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0xFFFA5F1A), blurRadius: 40)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(vendor.name,
                                            style: const TextStyle(
                                                fontSize: 24,
                                                color: Color(0xFFFA5F1A),
                                                fontWeight: FontWeight.bold)),
                                        Text(vendor.address!,
                                            style:
                                                const TextStyle(fontSize: 18)),
                                        const SizedBox(height: 10),
                                        if (averageRating != null)
                                          RatingBar.builder(
                                            initialRating: averageRating!,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 30,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 1),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {},
                                          )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Expanded(
                          child: DefaultTabController(
                            length: categories.length,
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.375 *
                                      (categories.length <= 3
                                          ? categories.length
                                          : 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF6F0F0),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.orange,
                                      width: 1,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      TabBar(
                                        labelColor: const Color(0xFFFA5F1A),
                                        unselectedLabelColor: Colors.grey,
                                        indicator: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color(0xffF6F0F0),
                                        ),
                                        tabs: [
                                          for (String category in categories)
                                            Tab(
                                              child: Container(
                                                width: (MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.75) /
                                                        2 -
                                                    0.5,
                                                alignment: Alignment
                                                    .center, // Center the text
                                                child: Text(
                                                  category,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      // Positioned(
                                      //   left: (MediaQuery.of(context).size.width *
                                      //               0.70) /
                                      //           2 -
                                      //       0.5,
                                      //   top: 0,
                                      //   bottom: 0,
                                      //   child: const VerticalDivider(
                                      //       color: Colors.orange, thickness: 1),
                                      // ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      for (int i = 0;
                                          i < categories.length;
                                          i++)
                                        ListView.builder(
                                          itemCount:
                                              categoriesFoods[categories[i]]!
                                                  .length,
                                          itemBuilder: (context, j) {
                                            Inventory categoryFood =
                                                categoriesFoods[categories[i]]![
                                                    j];
                                            int? quantity = selectedFoods
                                                .value['$i, $j']?['quantity'];
                                            bool showDecrease = selectedFoods
                                                .value
                                                .containsKey('$i, $j');
                                            return StatefulBuilder(
                                                builder: (context, setState) {
                                              return Card(
                                                shape: showDecrease
                                                    ? RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        side: const BorderSide(
                                                            color:
                                                                Colors.green))
                                                    : null,
                                                color: const Color(0xffF6F0F0),
                                                child: ListTile(
                                                  title: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 8, 0, 8),
                                                    child:
                                                        Text(categoryFood.name),
                                                  ),
                                                  subtitle: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 0, 8),
                                                    child: Text(
                                                        '\$ ${categoryFood.price}',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18,
                                                            color: Color(
                                                                0xFFFA5F1A))),
                                                  ),
                                                  trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                          (quantity ?? '')
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .green)),
                                                      GestureDetector(
                                                        onTap: () {
                                                          addButton(
                                                              selectedFoods,
                                                              '$i, $j',
                                                              categoryFood);
                                                          setState(() {
                                                            showDecrease = true;
                                                            quantity =
                                                                quantity == null
                                                                    ? 1
                                                                    : quantity! +
                                                                        1;
                                                          });
                                                          showCart.value = true;
                                                          items.value =
                                                              selectedFoods
                                                                  .value.length;
                                                        },
                                                        child: const Icon(
                                                          Icons.add,
                                                          color:
                                                              Color(0xFFFA5F1A),
                                                          size: 40,
                                                        ),
                                                      ),
                                                      if (showDecrease)
                                                        GestureDetector(
                                                          onTap: () =>
                                                              setState(() {
                                                            showDecrease =
                                                                decreaseButton(
                                                                    selectedFoods,
                                                                    '$i, $j',
                                                                    categoryFood);
                                                            quantity = (quantity ==
                                                                        null ||
                                                                    quantity! <=
                                                                        1)
                                                                ? null
                                                                : quantity! - 1;
                                                            if (selectedFoods
                                                                .value
                                                                .isEmpty) {
                                                              showCart.value =
                                                                  false;
                                                            }
                                                            items.value =
                                                                selectedFoods
                                                                    .value
                                                                    .length;
                                                          }),
                                                          child: const Icon(
                                                            Icons.remove,
                                                            color: Color(
                                                                0xFFFA5F1A),
                                                            size: 40,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  addButton(ValueNotifier<Map<String, Map<String, dynamic>>> selectedFoods, key,
      categoryFood) {
    Map<String, Map<String, dynamic>> previousSelectedFoods =
        selectedFoods.value;

    if (selectedFoods.value.containsKey(key)) {
      Map<String, dynamic> previousFood = selectedFoods.value[key]!;
      previousSelectedFoods.update(
          key,
          (value) => {
                'food': previousFood['food'],
                'quantity': previousFood['quantity'] + 1
              });
    } else {
      previousSelectedFoods.addAll({
        key: {'food': categoryFood, 'quantity': 1}
      });
    }

    selectedFoods.value = previousSelectedFoods;
  }

  bool decreaseButton(
      ValueNotifier<Map<String, Map<String, dynamic>>> selectedFoods,
      key,
      categoryFood) {
    Map<String, Map<String, dynamic>> previousSelectedFoods =
        selectedFoods.value;
    Map<String, dynamic> previousFood = previousSelectedFoods[key]!;

    if (previousFood['quantity'] == 1) {
      previousSelectedFoods.remove(key);
      selectedFoods.value = previousSelectedFoods;
      return false;
    }
    previousSelectedFoods.update(
        key,
        (value) => {
              'food': previousFood['food'],
              'quantity': previousFood['quantity'] - 1
            });
    selectedFoods.value = previousSelectedFoods;
    return true;
  }
}
