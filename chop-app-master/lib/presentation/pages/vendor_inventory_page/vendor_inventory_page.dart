import 'package:chop/core/components/loading.dart';
import 'package:chop/core/mixins/mixins.dart';
import 'package:chop/domain/model/inventory.dart';
import 'package:chop/domain/use_cases/delete_inventory_use_case.dart';
import 'package:chop/presentation/pages/vendor_add_item_page/vendor_add_item_page.dart';
import 'package:chop/presentation/pages/vendor_inventory_page/cubit/vendor_inventory_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

import '../../../di.dart';

class VendorInventoryPage extends HookWidget with ErrorDialog {
  const VendorInventoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shownFoods = useState<List<Inventory>>([]);
    // final firstRun = useState(true);
    final toRemove = useState<List<Inventory>>([]);
    final searchString = useState('');
    return BlocProvider(
      create: (context) => sl<VendorInventoryPageCubit>()..getInventories(),
      child: BlocConsumer<VendorInventoryPageCubit, VendorInventoryPageState>(
        listener: (context, state) {
          if (state is VendorInventoryPageSignOut) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/login', (route) => false);
          } else if (state is VendorInventoryPageError) {
            errorDialog(context, state.errorMessage,
                onPressed: () => Navigator.of(context).pop());
            BlocProvider.of<VendorInventoryPageCubit>(context).getInventories();
          }
        },
        builder: (buildContext, state) {
          if (state is! VendorInventoryPageInitial) {
            return loadingWidget(context);
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (searchString.value == '') {
              shownFoods.value = state.inventories;
            } else {
              shownFoods.value = [];

              for (var food in state.inventories) {
                if (food.name
                    .toLowerCase()
                    .contains(searchString.value.toLowerCase())) {
                  shownFoods.value.add(food);
                }
              }
            }
          });

          shownFoods.value.removeWhere((e) => toRemove.value.contains(e));
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
                            searchString.value = text;
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
                      IconButton(
                          onPressed: () => showDialog(
                              context: buildContext,
                              builder: (dialogContext) {
                                DateTime? fromDate;
                                DateTime? toDate;

                                final now = DateTime.now();

                                int min = 0;
                                int? max;

                                return StatefulBuilder(builder:
                                    (statefulBuilderContext, setState) {
                                  return Dialog(
                                    backgroundColor: const Color(0xFFF6F0F0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.sort),
                                              SizedBox(width: 10),
                                              Text('Filters',
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                            ],
                                          ),
                                          const Text('Filter by date'),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              GestureDetector(
                                                  onTap: () async {
                                                    DateTime? newDate =
                                                        await showDatePicker(
                                                      context:
                                                          statefulBuilderContext,
                                                      initialDate:
                                                          toDate ?? now,
                                                      firstDate: DateTime(
                                                          now.year - 10),
                                                      lastDate: toDate ?? now,
                                                    );
                                                    setState(() =>
                                                        fromDate = newDate);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons
                                                          .calendar_month_outlined),
                                                      const SizedBox(width: 10),
                                                      Column(
                                                        children: [
                                                          const Text(
                                                              'From date'),
                                                          Text(fromDate == null
                                                              ? '--/--/----'
                                                              : DateFormat(
                                                                      'dd/MM/yyyy')
                                                                  .format(
                                                                      fromDate!))
                                                        ],
                                                      )
                                                    ],
                                                  )),
                                              Container(
                                                  height: 30,
                                                  width: 1,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.grey)),
                                              GestureDetector(
                                                  onTap: () async {
                                                    DateTime? newDate =
                                                        await showDatePicker(
                                                      context:
                                                          statefulBuilderContext,
                                                      initialDate: now,
                                                      firstDate: fromDate ??
                                                          DateTime(
                                                              now.year - 10),
                                                      lastDate: now,
                                                    );
                                                    setState(
                                                        () => toDate = newDate);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons
                                                          .calendar_month_outlined),
                                                      const SizedBox(width: 10),
                                                      Column(
                                                        children: [
                                                          const Text('To date'),
                                                          Text(toDate == null
                                                              ? '--/--/----'
                                                              : DateFormat(
                                                                      'dd/mm/yyyy')
                                                                  .format(
                                                                      toDate!))
                                                        ],
                                                      )
                                                    ],
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          const Text('Filter by stock'),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                const Text('Min: '),
                                                SizedBox(
                                                  width: 50,
                                                  child: TextField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged: (value) =>
                                                          setState(() => min =
                                                              int.tryParse(
                                                                      value) ??
                                                                  0)),
                                                ),
                                                const Text('Max: '),
                                                SizedBox(
                                                  width: 50,
                                                  child: TextField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged: (value) =>
                                                          setState(() => max =
                                                              int.tryParse(
                                                                  value))),
                                                ),
                                              ]),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          elevation: 0,
                                                          backgroundColor:
                                                              Colors.white,
                                                          side: const BorderSide(
                                                              color: Color(
                                                                  0xFFFA5F1A))),
                                                  onPressed: () => Navigator.of(
                                                          statefulBuilderContext)
                                                      .pop(),
                                                  child: const Text('Back',
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFFFA5F1A)))),
                                              const SizedBox(width: 10),
                                              if (max == null || max! > min)
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            elevation: 0,
                                                            backgroundColor:
                                                                const Color(
                                                                    0xFFFA5F1A),
                                                            side: const BorderSide(
                                                                color: Colors
                                                                    .white)),
                                                    onPressed: () {
                                                      List<Inventory>
                                                          tempShownFoods =
                                                          state.inventories;
                                                      List<Inventory>
                                                          tempToRemove = [];
                                                      for (var food
                                                          in tempShownFoods) {
                                                        if (fromDate != null &&
                                                            food.createdAt
                                                                .isBefore(
                                                                    fromDate!)) {
                                                          tempToRemove
                                                              .add(food);
                                                        }

                                                        if (toDate != null &&
                                                            food.createdAt
                                                                .isAfter(
                                                                    toDate!)) {
                                                          tempToRemove
                                                              .add(food);
                                                        }

                                                        if (food.stock < min) {
                                                          tempToRemove
                                                              .add(food);
                                                        }

                                                        if (max != null &&
                                                            food.stock > max!) {
                                                          tempToRemove
                                                              .add(food);
                                                        }
                                                      }

                                                      Navigator.of(
                                                              statefulBuilderContext)
                                                          .pop();

                                                      toRemove.value =
                                                          tempToRemove;

                                                      BlocProvider.of<
                                                                  VendorInventoryPageCubit>(
                                                              buildContext)
                                                          .getInventories();
                                                    },
                                                    child: const Text('Apply',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              }).then((value) => null),
                          icon: const Icon(Icons.filter_alt_outlined,
                              color: Color(0xFFFA5F1A))),
                      IconButton(
                          onPressed: () => Navigator.of(buildContext).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const VendorAddItemPage())),
                          icon: const Icon(Icons.add_circle_outline,
                              color: Color(0xFFFA5F1A)))
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    itemCount: shownFoods.value.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (BuildContext context, int i) {
                      Inventory food = shownFoods.value[i];
                      return Card(
                        color: const Color(0xFFF6F0F0),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(food.name),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('\$${food.price} per pax'),
                                    if (food.discount != null)
                                      Text(
                                          ', ${food.discount! * 100}% discount')
                                  ],
                                ),
                                Text(
                                    '${DateFormat('dd-M-y').format(food.createdAt)} | ${food.stock} unit'),
                              ],
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    final nameController =
                                        TextEditingController();
                                    final stockController =
                                        TextEditingController();
                                    final priceController =
                                        TextEditingController();
                                    final discountController =
                                        TextEditingController();
                                    String name = food.name;
                                    int stock = food.stock;
                                    double price = food.price;
                                    double? discount = food.discount;
                                    nameController.text = name;
                                    stockController.text = stock.toString();
                                    priceController.text = price.toString();
                                    discountController.text = discount == null
                                        ? ''
                                        : (discount * 100).toString();
                                    showDialog(
                                        context: context,
                                        builder: (context) => StatefulBuilder(
                                                builder: (context, setState) {
                                              double? discountValue =
                                                  double.tryParse(
                                                      discountController.text);
                                              return AlertDialog(
                                                title: const Text('Edit item'),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Text('Name: '),
                                                          Expanded(
                                                            child: TextField(
                                                                onChanged:
                                                                    (value) =>
                                                                        setState(
                                                                            () {}),
                                                                keyboardType:
                                                                    TextInputType
                                                                        .name,
                                                                controller:
                                                                    nameController),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          const Text('Stock: '),
                                                          Expanded(
                                                            child: TextField(
                                                                onChanged:
                                                                    (value) =>
                                                                        setState(
                                                                            () {}),
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                controller:
                                                                    stockController),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          const Text('Price: '),
                                                          Expanded(
                                                            child: TextField(
                                                                onChanged:
                                                                    (value) =>
                                                                        setState(
                                                                            () {}),
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                controller:
                                                                    priceController),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          const Text(
                                                              'Discount: '),
                                                          Expanded(
                                                            child: TextField(
                                                                onChanged:
                                                                    (value) =>
                                                                        setState(
                                                                            () {}),
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                controller:
                                                                    discountController),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      child: const Text('Back',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey))),
                                                  if (nameController
                                                          .text.isNotEmpty &&
                                                      int.tryParse(
                                                              stockController
                                                                  .text) !=
                                                          null &&
                                                      double.tryParse(
                                                              priceController
                                                                  .text) !=
                                                          null &&
                                                      (discountValue != null &&
                                                          discountValue >= 1 &&
                                                          discountValue < 100))
                                                    TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      VendorInventoryPageCubit>(
                                                                  buildContext)
                                                              .updateInventory(
                                                                  food.id,
                                                                  nameController
                                                                      .text,
                                                                  food.category,
                                                                  int.parse(
                                                                      stockController
                                                                          .text),
                                                                  double.parse(
                                                                      priceController
                                                                          .text),
                                                                  double.parse(
                                                                          discountController
                                                                              .text) /
                                                                      100);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text('Apply'))
                                                ],
                                              );
                                            })).then((value) {
                                      BlocProvider.of<VendorInventoryPageCubit>(
                                              context)
                                          .getInventories();
                                    });
                                  },
                                  child: const Icon(Icons.edit,
                                      color: Colors.grey, size: 20)),
                              const SizedBox(width: 10),
                              GestureDetector(
                                  onTap: () => showDialog(
                                      context: context,
                                      builder: (dialogContext) => AlertDialog(
                                            content: const Text(
                                                'Are you sure you want to delete this food item?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () => Navigator.of(
                                                          dialogContext)
                                                      .pop(),
                                                  child: const Text('Cancel',
                                                      style: TextStyle(
                                                          color: Colors.grey))),
                                              TextButton(
                                                  onPressed: () {
                                                    BlocProvider.of<
                                                                VendorInventoryPageCubit>(
                                                            context)
                                                        .deleteInventory(
                                                            DeleteInventoryParams(
                                                                inventoryId:
                                                                    food.id));
                                                    Navigator.of(dialogContext)
                                                        .pop();
                                                  },
                                                  child: const Text('Delete'))
                                            ],
                                          )),
                                  child: const Icon(Icons.delete_outline,
                                      color: Colors.grey, size: 20)),
                            ],
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
}
