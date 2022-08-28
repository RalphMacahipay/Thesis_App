import 'package:accounts/enum/enum.dart';
import 'package:accounts/routes/route_pages.dart';
import 'package:accounts/services/auth/auth_service.dart';
import 'package:accounts/utility/logout_dialog.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //-----------------------------------logout button-------------------
    const logoutButton = PopupMenuItem<MenuAction>(
      value: MenuAction.logout,
      child: Text('Logout'),
    );
    //-----------------------------------PopUpbutton for logout (3 dots)--------
    final threeDOtsButton =
        PopupMenuButton<MenuAction>(onSelected: (value) async {
      switch (value) {
        case MenuAction.logout:
          final showLogout = await showLogoutDialog(context);
          if (showLogout) {
            await AuthService.firebase().logout();
            Navigator.of(context)
                .pushNamedAndRemoveUntil(loginPageRoute, (route) => false);
          }
      }
    }, itemBuilder: (context) {
      return [
        logoutButton,
      ];
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('This is homepage'),
        actions: [
          threeDOtsButton,
        ],
      ),
    );
  }
}
