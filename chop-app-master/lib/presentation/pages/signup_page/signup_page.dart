import 'package:chop/core/mixins/mixins.dart';
import 'package:chop/di.dart';
import 'package:chop/domain/use_cases/register_use_case.dart';
import 'package:chop/presentation/pages/main_page.dart';
import 'package:chop/presentation/pages/signup_page/cubit/signup_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with ErrorDialog {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  PhoneNumber? phoneNumber;
  final phoneNumberController = TextEditingController();

  String? role;
  String? location;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SignupPageCubit>(),
      child: BlocConsumer<SignupPageCubit, SignupPageState>(
        listener: (context, state) {
          if (state is SignupPageError) {
            errorDialog(context, state.errorMessage,
                onPressed: () => Navigator.of(context).pop());
          } else if (state is SignupSuccess) {
            if (state.user.role == "VENDOR" || state.user.role == "FII") {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MainPage(state.user)));
            } else {
              errorDialog(context, 'Unknown role.');
            }
          }
        },
        builder: (context, state) {
          if (state is SignupPageLoading) {
            return const Scaffold(
                body: SpinKitChasingDots(color: Color(0xFFFA5F1A)));
          }
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                // Background Circle
                Positioned(
                  bottom: -MediaQuery.of(context).size.width,
                  left: -MediaQuery.of(context).size.width * 0.8,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 2,
                    height: MediaQuery.of(context).size.width * 2.2,
                    decoration: BoxDecoration(
                      color: Color(0xFFFA5F1A),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Content
                Align(
                  alignment: Alignment.topCenter,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 40.0),
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: 230,
                                height: 100,
                              ),
                            ),
                            const Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'User Name',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              onChanged: (value) =>
                                  setState(() => nameController.text),
                              scrollPadding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                          70),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) =>
                                  setState(() => emailController.text),
                              scrollPadding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                          70),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: passwordController,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              obscureText: true,
                              onChanged: (value) =>
                                  setState(() => passwordController.text),
                              scrollPadding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                          70),
                            ),
                            const SizedBox(height: 12),
                            InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                print(number.phoneNumber);
                                setState(() {
                                  phoneNumber = number;
                                });
                              },
                              onInputValidated: (bool value) {
                                print(value);
                              },
                              selectorConfig: SelectorConfig(
                                selectorType:
                                    PhoneInputSelectorType.BOTTOM_SHEET,
                              ),
                              ignoreBlank: false,
                              autoValidateMode: AutovalidateMode.disabled,
                              selectorTextStyle: TextStyle(color: Colors.black),
                              initialValue: phoneNumber,
                              textFieldController: phoneController,
                              formatInput: false,
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: true, decimal: true),
                              inputBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              onSaved: (PhoneNumber number) {
                                print('On Saved: $number');
                              },
                              scrollPadding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                          70),
                            ),
                            const SizedBox(height: 12),
                            if (role == 'VENDOR')
                              TextField(
                                controller: addressController,
                                decoration: const InputDecoration(
                                  labelText: 'Address',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                onChanged: (value) async {
                                  String? locationValue =
                                      await getLocations(value);
                                  if (locationValue != null) {
                                    setState(() => location = locationValue);
                                  }
                                },
                                onEditingComplete: () async {
                                  String? locationValue = await getLocations(
                                      addressController.text);
                                  if (locationValue != null) {
                                    setState(() => location = locationValue);
                                  }
                                },
                              ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              hint: const Text('Please select'),
                              items: const [
                                DropdownMenuItem(
                                  value: 'VENDOR',
                                  child: Text('Vendors'),
                                ),
                                DropdownMenuItem(
                                  value: 'FII',
                                  child: Text('Food Insecure Individual'),
                                ),
                              ],
                              onChanged: (String? newValue) {
                                setState(() => role = newValue);
                              },
                            ),
                            const SizedBox(height: 24),
                            if (nameController.text.isNotEmpty &&
                                emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty &&
                                phoneController.text.isNotEmpty &&
                                role != null)
                              if (role == 'FII' ||
                                  (role == 'VENDOR' &&
                                      addressController.text.isNotEmpty &&
                                      location != null))
                                SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.3, // Set the width
                                  child: ElevatedButton(
                                    onPressed: () => BlocProvider.of<
                                            SignupPageCubit>(context)
                                        .signUp(RegisterParams(
                                            name: nameController.text,
                                            email: emailController.text,
                                            password: passwordController.text,
                                            phone:
                                                '${phoneNumber?.phoneNumber}',
                                            address: addressController.text,
                                            location: location,
                                            role: role!)),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      backgroundColor: Colors
                                          .white, // Set the text color to black
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            30), // Set the border radius
                                      ),
                                    ),
                                    child: const Text(
                                      'Sign up',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Already have an account? '),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                  ),
                                  child: RichText(
                                    text: const TextSpan(
                                      text: 'Log In',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).viewInsets.bottom),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<String?> getLocations(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return '${locations[0].latitude},${locations[0].longitude}';
      }
    } on Exception {
      return null;
    }
    return null;
  }
}
