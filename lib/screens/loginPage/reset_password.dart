import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_appointment_app/screens/loginPage/signin_screen.dart';
import 'package:flutter_appointment_app/widgets/reusable_widget.dart';
//import 'package:curare/screens/home_screen.dart';
import 'package:flutter_appointment_app/theme/color_utils.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Center(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              hexStringToColor("E5E6E4"),
              hexStringToColor("F2F3F2"),
              hexStringToColor("FFFFFF")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
              child: Column(
                children: <Widget>[
                  const Text(
                    "Reset Password",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  reusableTextField("Enter Email Id", Icons.person_outline,
                      false, _emailTextController),
                  const SizedBox(
                    height: 20,
                  ),
                  firebaseUIButton(context, "Reset Password", () async {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(
                            email: _emailTextController.text)
                        .then((value) => Navigator.of(context).pop());
                  }),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SignInScreen(),
                          ));
                    },
                    child: Text('Back to login page?',
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ))),
      ),
    );
  }
}
