import 'package:face_attendance/core/auth/controllers/login_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';

class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              const Text(
                'Oops! Something went wrong.',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'We\'re sorry for the inconvenience. Our team has been notified and is working on fixing the issue.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (kDebugMode)
                Text(
                  'Error details: $error',
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 32),
              ElevatedButton(
                child: const Text('Restart App'),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Restart.restartApp(
                    notificationTitle: 'Restarting App',
                    notificationBody: 'Please tap here to open the app again.',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
