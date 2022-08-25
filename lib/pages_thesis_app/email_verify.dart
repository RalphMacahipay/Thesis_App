import 'package:accounts/routes/route_pages.dart';
import 'package:accounts/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtool show log;

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    // ---------------------------> Back Button <---------------------------
    final backButton = ElevatedButton(
      onPressed: () async {
        AuthService.firebase().logout();
        Navigator.of(context)
            .pushNamedAndRemoveUntil(registerPageRoute, (route) => false);
      },
      child: const Text('Back'),
    );

    // ---------------------------> verify Button <---------------------------
    final verifyButton = TextButton(
        onPressed: () async {
          AuthService.firebase().sendEmailVerification();
        },
        child: const Text('Resend code'));
    // ---------------------------> Scaffold <---------------------------
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Column(
        children: [
          const Text('Verify your email'),
          verifyButton,
          backButton,
        ],
      ),
    );
  }
}
