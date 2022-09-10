// ignore_for_file: file_names, unused_local_variable, deprecated_member_use
import 'package:accounts/image_code/images_code.dart';
import 'package:accounts/routes/route_pages.dart';
import 'package:accounts/services/auth/auth_exception.dart';
import 'package:accounts/services/auth/auth_service.dart';
import 'package:accounts/utility/error_dialog.dart';

import 'package:flutter/material.dart';
import 'dart:developer' as devtool show log;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    devtool.log("dispose Start");
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onButtonTappedHomePage() async {
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    Navigator.of(context)
        .pushNamedAndRemoveUntil(homePageRoute, (route) => false);
  }

  void onButtonTappedVerify() async {
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    Navigator.of(context)
        .pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
  }

  void onButtonTappedLogIn() async {
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    Navigator.of(context)
        .pushNamedAndRemoveUntil(loginPageRoute, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // ---------------------------> email input <---------------------------
    final inputEmail = TextFormField(
      enableSuggestions: true,
      autocorrect: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      // ---------------------------> Not now
      validator: (value) {
        RegExp regex = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
        );
        if (value!.isEmpty) {
          return ("Please enter your email");
        }
        if (!regex.hasMatch(value)) {
          return ("Invalid email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      decoration: InputDecoration(
          hintText: "Enter your email",
          labelText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          )),
      textInputAction: TextInputAction.next,
    );

    // ---------------------------> password input <---------------------------

    final inputPassword = TextFormField(
      enableSuggestions: false,
      autocorrect: false,

      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      // ---------------------------> Not now
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Please enter your password");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password (Min. 6 characters)");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },

      decoration: InputDecoration(
          hintText: "Enter your password",
          labelText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          )),
      textInputAction: TextInputAction.done,
    );

// ---------------------------> Forgot Password Button <------------------
    final forgotButton = FlatButton(
      child: const Text("Button"),
      onPressed: () {},
    );

// ---------------------------> Login Button <---------------------------

    final loginButton = ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          final email = emailController.text;
          final password = passwordController.text;
          try {
            await AuthService.firebase()
                .login(email: email, password: password);
            final user = AuthService.firebase().currentUser;

            if (user?.isEmailVerified ?? false) {
              onButtonTappedHomePage();
            } else {
              onButtonTappedVerify();
            }
          } on UserNotFoundAuthException {
            await showErrorDialog(context, 'User not Found');
          } on WrongPasswordAuthException {
            await showErrorDialog(context, 'Wrong Password');
          } on GenericAuthException {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: const Text("Login"),
    );
// ---------------------------> Don't Have an aaccount (Text)<--------------
    const noAccountText = Text("Not a member create an account ");
// ---------------------------> Register Button <---------------------------
    final registerButton = TextButton(
      onPressed: () async {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(registerPageRoute, (route) => false);
      },
      child: const Text(
        'HERE',
        style: TextStyle(color: Colors.white),
      ),
    );
// ---------------------------> Scaffold <---------------------------
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(logo),
                inputEmail,
                inputPassword,
                forgotButton,
                loginButton,
                Column(
                  children: [
                    noAccountText,
                    registerButton,
                  ],
                ),
              ],
            ),
          ),
        ), /* add child content here */
      ),
    );
  }
}
