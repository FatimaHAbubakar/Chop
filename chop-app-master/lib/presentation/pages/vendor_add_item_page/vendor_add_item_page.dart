import 'package:chop/core/components/loading.dart';
import 'package:chop/core/mixins/mixins.dart';
import 'package:chop/di.dart';
import 'package:chop/domain/use_cases/create_inventory_use_case.dart';
import 'package:chop/presentation/pages/main_page.dart';
import 'package:chop/presentation/pages/vendor_add_item_page/cubit/vendor_add_item_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VendorAddItemPage extends StatefulWidget {
  const VendorAddItemPage({Key? key}) : super(key: key);

  @override
  State<VendorAddItemPage> createState() => _VendorAddItemPageState();
}

class _VendorAddItemPageState extends State<VendorAddItemPage>
    with ErrorDialog {
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final stockController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<VendorAddItemPageCubit>()..getUser(),
      child: BlocConsumer<VendorAddItemPageCubit, VendorAddItemPageState>(
        listener: (context, state) {
          if (state is VendorAddItemPageSignOut) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/login', (route) => false);
          } else if (state is VendorAddItemPageError) {
            errorDialog(context, state.errorMessage,
                onPressed: () => Navigator.of(context).pop());
            BlocProvider.of<VendorAddItemPageCubit>(context).getUser();
          } else if (state is VendorAddItemSuccess) {
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
                          Text('New item added successfully',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20))
                        ],
                      ),
                    ))).then((value) => Navigator.of(context)
                .pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => MainPage(state.user)),
                    (route) => false));
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: state is! VendorAddItemPageInitial
                ? loadingWidget(context)
                : SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          const Expanded(child: SizedBox()),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: const Color(0xFFf6f0f0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const SizedBox(height: 50),
                                      const Text('ADD NEW ITEM',
                                          style: TextStyle(fontSize: 25)),
                                      const SizedBox(height: 50),
                                      TextFormField(
                                        controller: nameController,
                                        decoration: const InputDecoration(
                                            hintText: 'Item name'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter item name';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        controller: categoryController,
                                        decoration: const InputDecoration(
                                            hintText: 'Item category'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter item category';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        controller: stockController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            hintText: 'Item stock'),
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty ||
                                              int.tryParse(value) == null) {
                                            return 'Please enter valid item stock';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        controller: priceController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            hintText: 'Item price'),
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty ||
                                              double.tryParse(value) == null) {
                                            return 'Please enter valid item price';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        controller: discountController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            hintText:
                                                'Item discount in % (for example: 25)'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return null;
                                          }
                                          double? discount =
                                              double.tryParse(value);
                                          if (discount == null ||
                                              discount < 1 ||
                                              discount > 99) {
                                            return 'Please enter valid item discount';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 50),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  backgroundColor: Colors.white,
                                                  side: const BorderSide(
                                                      color:
                                                          Color(0xFFFA5F1A))),
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text('Back',
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xFFFA5F1A)))),
                                          const SizedBox(width: 10),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  backgroundColor:
                                                      const Color(0xFFFA5F1A),
                                                  side: const BorderSide(
                                                      color: Colors.white)),
                                              onPressed: () {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  double? discount =
                                                      double.tryParse(
                                                          discountController
                                                              .text);
                                                  BlocProvider.of<
                                                              VendorAddItemPageCubit>(
                                                          context)
                                                      .addItem(
                                                          CreateInventoryParams(
                                                              name: nameController
                                                                  .text,
                                                              category:
                                                                  categoryController
                                                                      .text,
                                                              stock: int.parse(
                                                                  stockController
                                                                      .text),
                                                              price:
                                                                  double.parse(
                                                                      priceController
                                                                          .text),
                                                              discount:
                                                                  discount ==
                                                                          null
                                                                      ? 0
                                                                      : discount /
                                                                          100,
                                                              vendorId: (state)
                                                                  .vendor
                                                                  .id));
                                                }
                                              },
                                              child: const Text('Apply',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Expanded(child: SizedBox())
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
