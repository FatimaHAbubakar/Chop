import 'package:chop/core/components/loading.dart';
import 'package:chop/core/mixins/mixins.dart';
import 'package:chop/di.dart';
import 'package:chop/domain/model/rescue.dart';
import 'package:chop/domain/model/rescue_inventory.dart';
import 'package:chop/presentation/pages/scan_qr_page.dart';
import 'package:chop/presentation/pages/vendor_rescue_page/cubit/vendor_rescue_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class VendorRescuePage extends HookWidget with ErrorDialog {
  const VendorRescuePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<VendorRescuePageCubit>()..getRescuesAndRescueInventories(),
      child: BlocConsumer<VendorRescuePageCubit, VendorRescuePageState>(
        listener: (context, state) {
          if (state is VendorRescuePageSignOut) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/login', (route) => false);
          } else if (state is VendorRescuePageError) {
            errorDialog(context, state.errorMessage,
                onPressed: () => Navigator.of(context).pop());
            BlocProvider.of<VendorRescuePageCubit>(context)
                .getRescuesAndRescueInventories();
          } else if (state is VendorRescuePageSuccess) {
            showDialog(
                context: context,
                builder: (context) => Dialog(
                    backgroundColor: const Color(0xFFf6f0f0),
                    child: Padding(
                      padding: const EdgeInsets.all(50),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 50,
                          ),
                          SizedBox(height: 30),
                          Text('Purchase completed',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20))
                        ],
                      ),
                    )));
            BlocProvider.of<VendorRescuePageCubit>(context)
                .getRescuesAndRescueInventories();
          }
        },
        builder: (context, state) {
          if (state is! VendorRescuePageInitial) return loadingWidget(context);
          return Expanded(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text('History', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    itemCount: state.rescues.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (BuildContext context, int i) {
                      Rescue rescue = state.rescues[i];
                      final status = rescue.status;
                      Color? statusColor;

                      switch (status.toLowerCase()) {
                        case 'pending':
                          statusColor = const Color.fromARGB(255, 213, 192, 0);
                          break;
                        case 'completed':
                          statusColor = Colors.green;
                          break;
                        case 'canceled':
                          statusColor = Colors.red;
                          break;
                        default:
                      }

                      List<RescueInventory> rescueInventories = [];
                      List<double> prices = [];
                      double rescueTotal = 0;

                      rescueInventories.addAll(state.rescueInventories.where(
                          (rescueInventory) =>
                              rescueInventory.rescue.id == rescue.id));

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
                                  Text('Ordered by ${rescue.fii.name}',
                                      style: const TextStyle(fontSize: 20)),
                                  const Expanded(child: SizedBox()),
                                  if (status.toLowerCase() == 'pending')
                                    GestureDetector(
                                      onTap: () async {
                                        final code = await Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    const ScanQRPage()));

                                        if (code != null) {
                                          // ignore: use_build_context_synchronously
                                          BlocProvider.of<
                                                      VendorRescuePageCubit>(
                                                  context)
                                              .verifyCode(code, rescue.id);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFFA5F1A),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: const Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Icon(
                                            Icons.qr_code_scanner,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                  DateFormat('dd-M-y').format(rescue.createdAt),
                                  style: const TextStyle(
                                      fontSize: 17, color: Colors.grey)),
                              const SizedBox(height: 10),
                              for (int i = 0; i < rescueInventories.length; i++)
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
