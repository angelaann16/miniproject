import 'package:flutter/material.dart';
import 'package:flutter_appointment_app/screens/loginPage/signin_screen.dart';
import 'package:flutter_appointment_app/theme/light_color.dart';
import 'package:flutter_appointment_app/theme/text_styles.dart';
import 'package:flutter_appointment_app/theme/extention.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 5)).then((_) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SignInScreen(),
          ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Opacity(
              opacity: .5,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 123, 0, 151),
                        Color.fromARGB(255, 0, 2, 117)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      tileMode: TileMode.mirror,
                      stops: [.5, 6]),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              Lottie.asset('assets/schedule.json', width: 250, height: 250),
              SizedBox(height: 50),
              Lottie.asset('assets/loading.json', width: 100, height: 75),
              Text(
                "Zaphire",
                style: TextStyle(
                  fontSize: 40,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(8.433, 4.85),
                      blurRadius: 6.9,
                      color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                    )
                  ],
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "by Department of CSE",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 77, 76, 82)),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ).alignTopCenter,
        ],
      ),
    );
  }
}
