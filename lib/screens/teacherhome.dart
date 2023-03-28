import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appointment_app/screens/selectionScreen.dart';
import 'package:flutter_appointment_app/theme/extention.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import 'loginPage/signin_screen.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({Key key}) : super(key: key);

  @override
  _TeacherScreenState createState() => _TeacherScreenState();
}

var selected;

class _TeacherScreenState extends State<TeacherHomeScreen> {
  String _username;
  bool _isLoading = true;
  var appData;
  var stdData;
  @override
  void initState() {
    super.initState();
    _getUserName();
    _getAppDetatils();
    _getStddetails();
  }

  _getUserName() async {
    String userid = FirebaseAuth.instance.currentUser.uid;
    var user = await FirebaseFirestore.instance
        .collection('teachers')
        .doc(userid)
        .get();

    var data = user.data();
    if (data["name"] != null) {
      setState(() {
        _username = data["name"];
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  _getAppDetatils() async {
    setState(() {
      _isLoading = true;
    });
    var teacherid = FirebaseAuth.instance.currentUser.uid;
    var appointments = await FirebaseFirestore.instance
        .collection('appointments')
        .where('teacherid', isEqualTo: teacherid)
        .get();
    appData = appointments.docs.map((doc) => doc.data()).toList();
    setState(() {
      _isLoading = false;
    });
  }

  Future _getStddetails() async {
    var stddetails = await FirebaseFirestore.instance.collection('users').get();
    stdData = stddetails.docs.map((doc) => doc.data()).toList();
  }

  _getStdname(String id) {
    for (int i = 0; i < stdData.length; i++) {
      if (stdData[i]['id'] == id) {
        return stdData[i]['username'];
      }
    }
  }

  _appointTile() {
    return ListView.builder(
        itemCount: appData.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              selected = appData[index]['id'];
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => (SelectScreen()))))
                  .then((value) => _getAppDetatils());
            },
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      offset: Offset(4, 4),
                      blurRadius: 10,
                      color: LightColor.grey.withOpacity(.2),
                    ),
                    BoxShadow(
                      offset: Offset(-3, 0),
                      blurRadius: 15,
                      color: LightColor.grey.withOpacity(.1),
                    )
                  ],
                ),
                child: ListTile(
                  title: Text(_getStdname(appData[index]['studentid'])),
                  subtitle: Text(
                      "${appData[index]['stdemail']} \n${appData[index]['date'].toDate()}"),
                  trailing: Column(children: [
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                  ]),
                  isThreeLine: true,
                )),
          );
        });
  }

  Widget _header() {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Hello,",
                style: TextStyles.title.subTitleColor,
              ),
              Text(_username, style: TextStyles.h1Style),
              SizedBox(
                height: 20,
              ),
              Text(
                "Appointments pending :-",
                style: TextStyle(
                  fontSize: FontSizes.titleM,
                  color: Colors.black45,
                ),
              )
            ],
          ).p16;
  }

  Widget _appBar() {
    return AppBar(
      elevation: 3,
      backgroundColor: Theme.of(context).primaryColor,
      leading: IconButton(
        icon: Icon(Icons.logout_sharp),
        iconSize: 30,
        color: Colors.black,
        onPressed: () => {
          FirebaseAuth.instance.signOut(),
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => SignInScreen(),
              ))
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.notifications_none),
          iconSize: 30,
          color: LightColor.grey,
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          SizedBox(
            height: 20,
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: _appointTile(),
                ),
        ],
      ),
    );
  }
}
