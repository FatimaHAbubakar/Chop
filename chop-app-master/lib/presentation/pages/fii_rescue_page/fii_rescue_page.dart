import 'package:chop/core/components/loading.dart';
import 'package:chop/core/mixins/mixins.dart';
import 'package:chop/domain/model/rescue.dart';
import 'package:chop/domain/model/rescue_inventory.dart';
import 'package:chop/presentation/pages/fii_rescue_page/cubit/fii_rescue_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../di.dart';

class FIIRescuePage extends HookWidget with ErrorDialog {
  const FIIRescuePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firstRun = useState(true);
    final toRemove = useState<List<Rescue>>([]);
    final shownRescues = useState<List<Rescue>>([]);
    return BlocProvider(
      create: (context) =>
          sl<FIIRescuePageCubit>()..getRescuesAndRescueInventories(),
      child: BlocConsumer<FIIRescuePageCubit, FIIRescuePageState>(
        listener: (context, state) {
          if (state is FIIRescuePageSignOut) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/login', (route) => false);
          } else if (state is FIIRescuePageError) {
            errorDialog(context, state.errorMessage,
                onPressed: () => Navigator.of(context).pop());
          }
        },
        builder: (context, state) {
          if (state is! FIIRescuePageInitial) return loadingWidget(context);
          if (firstRun.value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              shownRescues.value = state.rescues;
              firstRun.value = false;
            });
          }
          shownRescues.value.removeWhere((e) => toRemove.value.contains(e));
          return Expanded(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (text) {
                            if (text.isEmpty) {
                              shownRescues.value = state.rescues;
                            } else {
                              shownRescues.value = [];
                              for (var rescue in state.rescues) {
                                if (rescue.vendor.name
                                    .toLowerCase()
                                    .contains(text.toLowerCase())) {
                                  shownRescues.value.add(rescue);
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
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    itemCount: shownRescues.value.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (BuildContext context, int i) {
                      final shownRescue = shownRescues.value[i];
                      final status = shownRescue.status;
                      Color? statusColor;

                      List<RescueInventory> rescueInventories = [];
                      List<double> prices = [];
                      double rescueTotal = 0;

                      rescueInventories.addAll(state.rescueInventories.where(
                          (rescueInventory) =>
                              rescueInventory.rescue.id == shownRescue.id));

                      for (RescueInventory rescueInventory
                          in rescueInventories) {
                        double price = rescueInventory.inventory.price;
                        int quantity = rescueInventory.quantity;
                        double? discount = rescueInventory.inventory.discount;
                        double total = price * quantity;
                        if (discount != null) {
                          total = total - (total * discount);
                        }
                        prices.add(total);
                        rescueTotal += total;
                      }

                      switch (status.toLowerCase()) {
                        case 'pending':
                          statusColor = const Color.fromARGB(255, 193, 187, 7);
                          break;
                        case 'completed':
                          statusColor = Colors.green;
                          break;
                        case 'canceled':
                          statusColor = Colors.red;
                          break;
                        default:
                      }

                      return Card(
                        color: const Color(0xFFF6F0F0),
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Order from ${shownRescue.vendor.name}',
                                      style: const TextStyle(fontSize: 20)),
                                  const Expanded(child: SizedBox()),
                                  GestureDetector(
                                    onTap: () => showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                                child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    child: QrImage(
                                                        data: shownRescue.code),
                                                  ),
                                                  ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          elevation: 0,
                                                          backgroundColor:
                                                              Colors.white,
                                                          side: const BorderSide(
                                                              color: Color(
                                                                  0xFFFA5F1A))),
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      child: const Text('Back',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFFFA5F1A)))),
                                                ],
                                              ),
                                            ))),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFFA5F1A),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.qr_code_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                  DateFormat('dd-M-y')
                                      .format(shownRescue.createdAt),
                                  style: const TextStyle(
                                      fontSize: 17, color: Colors.grey)),
                              const SizedBox(height: 10),
                              for (i = 0; i < rescueInventories.length; i++)
                                Row(
                                  children: [
                                    Text(
                                        '${rescueInventories[i].quantity} pax ${rescueInventories[i].inventory.name}'),
                                    const Expanded(child: SizedBox()),
                                    Text('\$${prices[i].toStringAsFixed(1)}'),
                                  ],
                                ),
                              const Divider(color: Colors.black),
                              Row(
                                children: [
                                  const Text('Total'),
                                  const Expanded(child: SizedBox()),
                                  Text('\$${rescueTotal.toStringAsFixed(1)}'),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(status, style: TextStyle(color: statusColor))
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
