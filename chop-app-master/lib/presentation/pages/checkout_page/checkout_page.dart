import 'package:chop/core/mixins/mixins.dart';
import 'package:chop/domain/model/inventory.dart';
import 'package:chop/domain/model/user.dart';
import 'package:chop/domain/use_cases/checkout_use_case.dart';
import 'package:chop/presentation/pages/checkout_page/cubit/checkout_page_cubit.dart';
import 'package:chop/presentation/pages/rescue_success_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../di.dart';

class CheckoutPage extends HookWidget with ErrorDialog {
  final Map<String, Map<String, dynamic>> selectedFoods;
  final User vendor;

  const CheckoutPage(
      {super.key, required this.selectedFoods, required this.vendor});

  @override
  Widget build(BuildContext context) {
    final creditCard = useState(false);
    final eWallet = useState(false);

    final finalFoods = useState(selectedFoods);

    final total = useState(0.0);
    final totalBeforeDiscount = useState(0.0);
    total.value = 0;
    totalBeforeDiscount.value = 0;
    finalFoods.value.forEach((key, value) {
      var foodTotal =
          (value['food'] as Inventory).price * (value['quantity'] as int);
      totalBeforeDiscount.value += foodTotal;
      var discountPercentage = (value['food'] as Inventory).discount;
      var foodDiscount =
          discountPercentage == null ? 0 : discountPercentage * foodTotal;
      total.value += foodTotal - foodDiscount;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (total.value == 0) Navigator.of(context).pop();
    });

    void incrementQuantity(String foodName) {
      final updatedFoods = {...finalFoods.value};
      MapEntry<String, Map<String, dynamic>>? foodEntry;
      try {
        foodEntry = updatedFoods.entries
            .firstWhere((entry) => entry.value['food'].name == foodName);
      } on StateError {
        foodEntry = null;
      }
      if (foodEntry != null) {
        foodEntry.value['quantity']++;
        finalFoods.value = updatedFoods;
      }
    }

    decrementQuantity(String foodName) async {
      final updatedFoods = {...finalFoods.value};
      MapEntry<String, Map<String, dynamic>>? foodEntry;
      try {
        foodEntry = updatedFoods.entries.firstWhere(
          (entry) => entry.value['food'].name == foodName,
        );
      } on StateError {
        foodEntry = null;
      }
      if (foodEntry != null) {
        if (foodEntry.value['quantity'] > 1) {
          foodEntry.value['quantity']--;
        } else {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(
                  'Are you sure you want to delete ${foodEntry!.value['food'].name}?'),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
          ).then((value) {
            if (value) {
              updatedFoods.remove(foodEntry!.key);
              finalFoods.value = updatedFoods;
            }
          });
        }
        finalFoods.value = updatedFoods;
      }
    }

    return BlocProvider(
      create: (context) => sl<CheckoutPageCubit>(),
      child: BlocConsumer<CheckoutPageCubit, CheckoutPageState>(
        listener: (context, state) {
          if (state is CheckoutPageSignOut) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/login', (route) => false);
          } else if (state is CheckoutPageError) {
            errorDialog(context, state.errorMessage,
                onPressed: () => Navigator.of(context).pop());
            BlocProvider.of<CheckoutPageCubit>(context).goToInitial();
          } else if (state is CheckoutSuccess) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RescueSuccessPage(
                      rescue: state.rescue,
                      vendor: vendor,
                      fii: state.rescue.fii,
                    )));
          }
        },
        builder: (context, state) {
          bool discounted =
              double.parse(totalBeforeDiscount.value.toStringAsFixed(1)) >
                  double.parse(total.value.toStringAsFixed(1));
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Your cart',
                    style: TextStyle(color: Color(0xFFFA5F1A), fontSize: 25),
                  ),
                  const Divider(color: Color(0xFFFA5F1A), thickness: 1),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: StatefulBuilder(builder: (context, setState) {
                          int length = finalFoods.value.length;
                          return ListView.separated(
                              itemCount: length,
                              separatorBuilder: (context, index) => const Divider(
                                    thickness: 1,
                                  ),
                              itemBuilder: (context, i) {
                                final food = finalFoods.value.values.toList()[i];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(food['food'].name,
                                            style: const TextStyle(fontSize: 20)),
                                      ),
                                      GestureDetector(
                                          onTap: () => incrementQuantity(
                                              food['food'].name),
                                          child: const Icon(Icons.add,
                                              color: Color(0xFFFA5F1A))),
                                      const SizedBox(width: 5),
                                      Container(
                                          decoration: BoxDecoration(
                                              border:
                                                  Border.all(color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 2, 8, 2),
                                            child: Text(
                                                food['quantity'].toString(),
                                                style: const TextStyle(
                                                    fontSize: 20)),
                                          )),
                                      const SizedBox(width: 5),
                                      GestureDetector(
                                          onTap: () => decrementQuantity(
                                              food['food'].name),
                                          child: const Icon(Icons.remove,
                                              color: Color(0xFFFA5F1A))),
                                      const SizedBox(width: 20),
                                      SizedBox(
                                        width: 70,
                                        child: Text(
                                          '\$ ${(food['food'] as Inventory).price * (food['quantity'] as int)}',
                                          style: const TextStyle(
                                              color: Color(0xFFFA5F1A),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        })),
                  ),
                  const Divider(thickness: 1),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Total: ',
                              style: TextStyle(
                                  color: Color(0xFFFA5F1A),
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Expanded(child: SizedBox()),
                            if (discounted)
                              Text(
                                '\$ ${totalBeforeDiscount.value.toStringAsFixed(1)}',
                                style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold),
                              ),
                            const SizedBox(width: 20),
                            Text(
                              '\$ ${total.value.toStringAsFixed(1)}',
                              style: const TextStyle(
                                  color: Color(0xFFFA5F1A),
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        if (discounted)
                          Row(
                            children: const [
                              Expanded(child: SizedBox()),
                              Text(
                                'DISCOUNT',
                                style: TextStyle(
                                    color: Color(0xFFFA5F1A),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Payment method',
                    style: TextStyle(color: Color(0xFFFA5F1A), fontSize: 25),
                  ),
                  const Divider(color: Color(0xFFFA5F1A), thickness: 1),
                  const SizedBox(height: 10),
                  PaymentOption(
                      thisButton: creditCard,
                      otherButton: eWallet,
                      icon: Icons.credit_card,
                      text: 'Credit card'),
                  const SizedBox(height: 10),
                  PaymentOption(
                      thisButton: eWallet,
                      otherButton: creditCard,
                      icon: Icons.wallet,
                      text: 'eWallet'),
                  const Expanded(child: SizedBox()),
                  if (creditCard.value || eWallet.value)
                    OrangeIconButton(
                        onPressed: () => BlocProvider.of<CheckoutPageCubit>(
                                context)
                            .checkout(CheckOutParams(finalFoods.value, vendor)),
                        icon: Icons.attach_money,
                        text: 'Pay now'),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PaymentOption extends StatelessWidget {
  final ValueNotifier<bool> thisButton;
  final ValueNotifier<bool> otherButton;
  final IconData icon;
  final String text;

  const PaymentOption(
      {super.key,
      required this.thisButton,
      required this.otherButton,
      required this.icon,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
          onPressed: () {
            thisButton.value = true;
            otherButton.value = false;
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                      color: thisButton.value
                          ? const Color(0xFFFA5F1A)
                          : Colors.transparent)),
              elevation: 0,
              backgroundColor: const Color(0xffF6F0F0)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(
              children: [
                Row(
                  children: [
                    Icon(icon, size: 30, color: const Color(0xFFFA5F1A)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                          color: thisButton.value
                              ? const Color(0xFFFA5F1A)
                              : Colors.black,
                          fontSize: 23),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}

class OrangeIconButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String text;

  const OrangeIconButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
          onPressed: () => onPressed(),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 0,
              backgroundColor: const Color(0xFFFA5F1A)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30, color: Colors.white),
                Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 23),
                )
              ],
            ),
          )),
    );
  }
}
