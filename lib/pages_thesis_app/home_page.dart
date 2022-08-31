// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:accounts/enum/enum.dart';
import 'package:accounts/routes/route_pages.dart';
import 'package:accounts/services/auth/auth_service.dart';
import 'package:accounts/utility/logout_dialog.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();
  // ignore: prefer_const_constructors
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final Marker _kGooglePlexMarker = Marker(
    markerId: MarkerId("_kGooglePlex"),
    infoWindow: InfoWindow(title: "Google Plex"),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(37.42796133580664, -122.085749655962),
  );
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
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
      body: GoogleMap(
        mapType: MapType.normal,
        markers: {_kGooglePlexMarker},
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
