import 'package:flutter/material.dart';
import 'package:flutter_appointment_app/screens/splash_screen.dart';
import 'package:flutter_appointment_app/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCOS0QK5BdgyWeFvDUJ-wk2qjN8mn8kNbI",
          appId: "1085289847038:android:6c0a28e097c0b2b0ffedaf",
          messagingSenderId: "1085289847038",
          projectId: "appointment-ef8fc"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Appointment Scheduler',
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
      //routes: Routes.getRoute(),
      // onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
    );
  }
}
