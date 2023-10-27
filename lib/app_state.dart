import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  bool _isLocationEnabled = false;
  bool get isLocationEnabled => _isLocationEnabled;

  setLocationEnabled(bool value) async {
    _isLocationEnabled = value;
    notifyListeners();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });

    _isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    notifyListeners();

    Geolocator.getPositionStream().listen((position) {
      _isLocationEnabled = true;
      notifyListeners();
    });
  }
}
