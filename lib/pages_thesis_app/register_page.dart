import 'package:accounts/image_code/images_code.dart';
import 'package:accounts/routes/route_pages.dart';
import 'package:accounts/services/auth/auth_exception.dart';
import 'package:accounts/services/auth/auth_service.dart';
import 'package:accounts/utility/error_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devstool show log;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
    devstool.log("dispose Start");
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onButtonTappedVerify() async {
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    Navigator.of(context).pushNamed(verifyEmailRoute);
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

// ---------------------------> Register Button <---------------------------

    final registerButton = ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          final email = emailController.text;
          final password = passwordController.text;
          try {
            await AuthService.firebase().createUser(
              email: email,
              password: password,
            );

            await AuthService.firebase().sendEmailVerification();
            onButtonTappedVerify();
          } on UserAlreadyExistsAuthException {
            showErrorDialog(context, 'Email already exists');
          } on GenericAuthException {
            showErrorDialog(context, "Register failed");
          }
        }
      },
      child: const Text("Register"),
    );

// ---------------------------> Back Button <---------------------------
    final backButton = ElevatedButton(
      onPressed: () async {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(loginPageRoute, (route) => false);
      },
      child: const Text('Back'),
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
                registerButton,
                backButton
              ],
            ),
          ),
        ), /* add child content here */
      ),
    );
  }
}
