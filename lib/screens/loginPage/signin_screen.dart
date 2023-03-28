import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_appointment_app/screens/home_page_screen.dart';
import 'package:flutter_appointment_app/screens/teacherhome.dart';
import 'package:flutter_appointment_app/widgets/reusable_widget.dart';
//import 'package:curare/screens/home_screen.dart';
import 'package:flutter_appointment_app/screens/loginPage/reset_password.dart';
import 'package:flutter_appointment_app/screens/loginPage/signup_screen.dart';
import 'package:flutter_appointment_app/theme/color_utils.dart';
import 'package:flutter/material.dart';

//import 'package:curare/pages/uhome.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  String dropdownValue = 'Student';
  String user;
  var role;
  @override
  void initState() {
    super.initState();
  }

  _getuserdata() async {
    QuerySnapshot collection = await FirebaseFirestore.instance
        .collection('teachers')
        .where('email', isEqualTo: _emailTextController.text)
        .get();
    role = 'teacher';
    if (collection.size == 0) {
      role = 'student';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                const Text(
                  "Login To Your Account",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 44.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: 200,
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    isExpanded: true,
                    icon: const Icon(Icons.face_rounded),
                    elevation: 16,
                    borderRadius: BorderRadius.circular(30.0),
                    focusColor: Colors.black,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        user = dropdownValue;
                      });
                    },
                    items: <String>['Student', 'Teacher']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email-id", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 5,
                ),
                forgetPassword(context),
                SizedBox(
                  width: 200,
                  child: firebaseUIButton(context, "Sign In", () {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text)
                        .then((value) async {
                      await _getuserdata();
                      if (user == 'Student' && role == 'student') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePageScreen()));
                      } else if (user == 'Teacher' && role == 'teacher') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TeacherHomeScreen()));
                      } else {
                        final snackBar = SnackBar(
                          content: Text("User not found"),
                          duration: Duration(seconds: 5),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }).onError((error, stackTrace) {
                      print("Error ${error.toString()}");
                    });
                  }),
                ),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?", style: TextStyle(color: Colors.blue)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.blue),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }
}
