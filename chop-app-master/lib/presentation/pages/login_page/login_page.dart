import 'package:chop/core/mixins/mixins.dart';
import 'package:chop/di.dart';
import 'package:chop/domain/use_cases/login_use_case.dart';
import 'package:chop/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'cubit/login_page_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with ErrorDialog {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginPageCubit>(),
      child: BlocConsumer<LoginPageCubit, LoginPageState>(
        listener: (context, state) {
          if (state is LoginPageError) {
            errorDialog(context, state.errorMessage,
                onPressed: () => Navigator.of(context).pop());
          } else if (state is LoginSuccess) {
            if (state.user.role == "VENDOR" || state.user.role == "FII") {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MainPage(state.user)),
                (route) => false,
              );
            } else {
              errorDialog(context, 'Unknown role.');
            }
          }
        },
        builder: (context, state) {
          if (state is LoginPageLoading) {
            return const Scaffold(
                body: SpinKitChasingDots(color: Color(0xFFFA5F1A)));
          }
          return Scaffold(
            body: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/Login Page.png',
                    fit: BoxFit.cover,
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
                              padding: const EdgeInsets.only(bottom: 100.0),
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: 230,
                                height: 100,
                              ),
                            ),
                            const Text(
                              'Log In',
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            TextField(
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
                                  setState(() => emailController.text = value),
                            ),
                            const SizedBox(height: 12),
                            TextField(
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
                              onChanged: (value) => setState(
                                  () => passwordController.text = value),
                            ),
                            const SizedBox(height: 24),
                            if (emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty)
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.3, // Set the width
                                child: ElevatedButton(
                                  onPressed: () =>
                                      BlocProvider.of<LoginPageCubit>(context)
                                          .login(LoginParams(
                                              email: emailController.text,
                                              password:
                                                  passwordController.text)),
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
                                    'Sign in',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Don’t have an account yet? '),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/signup');
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
}
