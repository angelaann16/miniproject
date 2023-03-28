import 'package:flutter_appointment_app/model/firestore_helper.dart';
import 'package:flutter_appointment_app/screens/loginPage/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_appointment_app/widgets/reusable_widget.dart';
import 'package:flutter_appointment_app/theme/color_utils.dart';
import 'package:flutter/material.dart';

import '../../model/user_model.dart';
//import 'package:curare/data/remote_data_source/firestore_helper.dart';
//import 'package:curare/data/models/user_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _pname = TextEditingController();
  TextEditingController _pno = TextEditingController();
  @override
  void dispose() {
    _pname.dispose();
    _pno.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
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
                  "Create Your Account",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Enter Your Name", Icons.person_outline, false, _pname),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email Id", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outlined, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Phone Number", Icons.person_outline, false, _pno),
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
                SizedBox(
                  width: 200,
                  child: firebaseUIButton(context, "Sign Up", () async {
                    await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text)
                        .then((value) {
                      print("Created New Account");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()));
                    }).onError((error, stackTrace) {
                      print("Error ${error.toString()}");
                    });
                    String userid = FirebaseAuth.instance.currentUser.uid;
                    await FirestoreHelper.create(UserModel(
                        id: userid, username: _pname.text, phnNo: _pno.text));
                  }),
                )
              ],
            ),
          ))),
    );
  }

  container({Container child}) {}
}
