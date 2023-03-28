import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appointment_app/model/teachermodel.dart';
import 'package:flutter_appointment_app/screens/detail_screen.dart';
import 'package:flutter_appointment_app/screens/facultylist.dart';
import 'package:flutter_appointment_app/screens/loginPage/signin_screen.dart';
import 'package:flutter_appointment_app/theme/light_color.dart';
import 'package:flutter_appointment_app/theme/text_styles.dart';
import 'package:flutter_appointment_app/theme/extention.dart';
import 'package:flutter_appointment_app/theme/theme.dart';

var dep;
var selectedTile;

class HomePageScreen extends StatefulWidget {
  HomePageScreen({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageScreen> {
  List<TeacherModel> teacherdatalist;
  String _username = "";
  bool _isLoading = true;
  Stream teacherStream;

  @override
  void initState() {
    super.initState();
    _getUserName();
    _buildStream();
  }

  _buildStream() {
    setState(() {
      teacherStream = _getTeacherData();
    });
  }

  static Stream<List<TeacherModel>> _getTeacherData() {
    final teacherDataList = FirebaseFirestore.instance.collection("teachers");
    return teacherDataList.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => TeacherModel.fromSnapshot(e)).toList());
  }

  _getUserName() async {
    setState(() {
      _isLoading = true;
    });
    String userid = FirebaseAuth.instance.currentUser.uid;
    var user =
        await FirebaseFirestore.instance.collection('users').doc(userid).get();

    var data = user.data();
    if (data["username"] != null) {
      setState(() {
        _username = data["username"];
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
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
        ),
      ],
    );
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
            ],
          ).p16;
  }

  Widget _searchField() {
    return Container(
      height: 55,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(13)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: LightColor.grey.withOpacity(.3),
            blurRadius: 15,
            offset: Offset(5, 5),
          )
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          hintText: "Search",
          hintStyle: TextStyles.body.subTitleColor,
          suffixIcon: SizedBox(
            width: 50,
            child:
                Icon(Icons.search, color: LightColor.purple).alignCenter.ripple(
                      () {},
                      borderRadius: BorderRadius.circular(50),
                    ),
          ),
        ),
      ),
    );
  }

  Widget _category() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Departments", style: TextStyles.title.bold),
              Text(
                "See All",
                style: TextStyles.titleNormal
                    .copyWith(color: Theme.of(context).primaryColor),
              ).p(8).ripple(() {})
            ],
          ),
        ),
        SizedBox(
          height: AppTheme.fullHeight(context) * .28,
          width: AppTheme.fullWidth(context),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              _categoryCardWidget("Chemical Department", "17 Faculties",
                  color: LightColor.green,
                  lightColor: LightColor.lightGreen, onPressed: () {
                dep = 'Chemical Department';
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FacultyList()));
              }),
              _categoryCardWidget("Civil Department", "40 faculties",
                  color: LightColor.skyBlue,
                  lightColor: LightColor.lightBlue, onPressed: () {
                dep = 'Civil Department';
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FacultyList()));
              }),
              _categoryCardWidget("Computer Science Department", "31 faculties",
                  color: LightColor.orange,
                  lightColor: LightColor.lightOrange, onPressed: () {
                dep = 'Computer Science Department';
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FacultyList()));
              }),
              _categoryCardWidget("Mechanical Department", "32 faculties",
                  color: Color.fromARGB(255, 217, 120, 252),
                  lightColor: Color.fromARGB(255, 234, 128, 251),
                  onPressed: () {
                dep = 'Mechanical Department';
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FacultyList()));
              })
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryCardWidget(
    String title,
    String subtitle, {
    Color color,
    Color lightColor,
    Function onPressed,
  }) {
    TextStyle titleStyle = TextStyles.title.bold.white;
    TextStyle subtitleStyle = TextStyles.body.bold.white;
    if (AppTheme.fullWidth(context) < 392) {
      titleStyle = TextStyles.body.bold.white;
      subtitleStyle = TextStyles.bodySm.bold.white;
    }
    return AspectRatio(
      aspectRatio: 7 / 9,
      child: Container(
        height: 280,
        width: AppTheme.fullWidth(context) * .3,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(4, 4),
              blurRadius: 10,
              color: lightColor.withOpacity(.8),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -20,
                  left: -20,
                  child: CircleAvatar(
                    backgroundColor: lightColor,
                    radius: 60,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      child: Text(title, style: titleStyle).hP8,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                      child: Text(
                        subtitle,
                        style: subtitleStyle,
                      ).hP8,
                    ),
                  ],
                ).p16
              ],
            ),
          ),
        ).ripple(onPressed,
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  Widget _teacherList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("All teachers", style: TextStyles.title.bold),
              IconButton(
                      icon: Icon(
                        Icons.sort,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {})
                  .p(12)
                  .ripple(() {},
                      borderRadius: BorderRadius.all(Radius.circular(20))),
            ],
          ).hP16,
          getteacherWidgetList()
        ],
      ),
    );
  }

  Widget getteacherWidgetList() {
    return Column(
      children: [
        StreamBuilder<List<TeacherModel>>(
            stream: _getTeacherData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("Some error occured"),
                );
              }
              if (snapshot.hasData) {
                final teacherData = snapshot.data;
                //return _teacherTile(teacherData);
                return Column(
                  children: teacherData.map((x) {
                    return _teacherTile(x);
                  }).toList(),
                );
              }
              return Center(
                child: Text(snapshot.hasData.toString()),
              );
            }),
      ],
    );

    //      teacherDataList.map((x) {
    //    return _teacherTile(x);
    //  }).toList());
  }

  Widget _teacherTile(TeacherModel model) {
    return Container(
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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(13)),
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                // color: randomColor(),
                color: Colors.white,
              ),
              child: Image.network(
                model.image,
                height: 50,
                width: 50,
                fit: BoxFit.contain,
              ),
            ),
          ),
          title: Text(model.name, style: TextStyles.title.bold),
          subtitle: Text(
            model.dept,
            style: TextStyles.bodySm.subTitleColor.bold,
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ).ripple(
        () {
          selectedTile = model.id;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailScreen(model.id),
              ));
        },
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );
  }

  Color randomColor() {
    var random = Random();
    final colorList = [
      Theme.of(context).primaryColor,
      LightColor.orange,
      LightColor.green,
      Color.fromARGB(255, 134, 242, 242),
      LightColor.lightOrange,
      Color.fromARGB(255, 255, 147, 178),
      Color.fromARGB(255, 123, 252, 166),
      Color.fromARGB(255, 128, 203, 253),
      Color.fromARGB(255, 250, 239, 121),
      LightColor.purpleExtraLight,
      LightColor.skyBlue,
    ];
    var color = colorList[random.nextInt(colorList.length)];
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Theme.of(context).backgroundColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _header(),
                _searchField(),
                _category(),
              ],
            ),
          ),
          _teacherList()
        ],
      ),
    );
  }
}
