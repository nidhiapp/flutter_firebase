//import 'dart:js_interop';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_firebase_project/helper/HelperFunction.dart';
import 'package:new_firebase_project/screens/Signupscreen.dart';
import 'package:new_firebase_project/screens/Loginscreen.dart';
import 'package:flutter/foundation.dart';
import 'package:new_firebase_project/screens/home_screen.dart';
import 'package:new_firebase_project/shared/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    //run the initialization for web

    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }

  void getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatus().then((value) {
      if (value != null) {
        _isSignedin = value;
      }
    });
  }

  bool isSignedUp = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Noteapp',
        home: _isSignedin ? ChatpageplusLogoutImplementation() : LoginScrenn());
  }
}
