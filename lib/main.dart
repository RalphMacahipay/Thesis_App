// import 'package:accounts/pages/email_verify.dart';
import 'package:accounts/pages/notes_view.dart';
// import 'package:accounts/pages/login_page.dart';
import 'package:accounts/pages/create_update_notes_view.dart';
// import 'package:accounts/pages/register_page.dart';
import 'package:accounts/pages_thesis_app/email_verify.dart';
import 'package:accounts/pages_thesis_app/home_page.dart';
import 'package:accounts/pages_thesis_app/login_page.dart';
import 'package:accounts/pages_thesis_app/register_page.dart';
import 'package:accounts/routes/route_pages.dart';
import 'package:accounts/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtool show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const InitializerPage(),
      routes: {
        registerPageRoute: (context) => const RegisterPage(),
        loginPageRoute: (context) => const LoginPage(),
        homePageRoute: (context) => const HomePage(),
        verifyEmailRoute: (context) => const VerifyEmail(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    );
  }
}

class InitializerPage extends StatefulWidget {
  const InitializerPage({Key? key}) : super(key: key);

  @override
  State<InitializerPage> createState() => _InitializerPageState();
}

class _InitializerPageState extends State<InitializerPage> {
  @override
  Widget build(BuildContext context) {
    // Para ma store yung user (no need na mag login pag verified na ang email)
    return FutureBuilder(
      // initializeApp (isang beses lang dapat gawin hindi per widget)
      future: AuthService.firebase().initialize(),
      builder: ((context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            //      return const LoginPage();
            if (user != null) {
              if (user.isEmailVerified) {
                return const HomePage();
              } else {
                return const VerifyEmail();
              }
            } else {
              return const LoginPage();
            }

          default:
            return const Text("Loading...");
        }
      }),
    );
  }
}
