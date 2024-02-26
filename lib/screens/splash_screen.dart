import 'dart:async';

import 'package:flutter/material.dart';
import 'package:Adhyayan/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

import '../services/local_notification_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late AuthViewModel _authViewModel;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animationController.repeat(reverse: true);

    // Wait for some time and then check login
    Timer(Duration(seconds: 3), () {
      checkLogin();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void checkLogin() async {
    String? token = ''; // Add logic to get Firebase Messaging token

    try {
      await _authViewModel.checkLogin(token);
      if (_authViewModel.user == null) {
        Navigator.of(context).pushReplacementNamed("/login");
      } else {
        NotificationService.display(
          title: "Welcome back",
          body:
          "Hello ${_authViewModel.loggedInUser?.name},\n We have been waiting for you.",
        );
        Navigator.of(context).pushReplacementNamed("/dashboard");
      }
    } catch (e) {
      Navigator.of(context).pushReplacementNamed("/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    _authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ScaleTransition(
              scale: _animationController.drive(
                CurveTween(curve: Curves.easeInOut),
              ),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    'Adhyayan',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
