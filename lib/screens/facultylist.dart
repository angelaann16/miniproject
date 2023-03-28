import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appointment_app/model/teachermodel.dart';
import 'package:flutter_appointment_app/screens/home_page_screen.dart';
import 'package:flutter_appointment_app/theme/extention.dart';

import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import 'detail_screen.dart';

class FacultyList extends StatefulWidget {
  FacultyList({
    Key key,
  }) : super(key: key);

  @override
  _FacultyListState createState() => _FacultyListState();
}

class _FacultyListState extends State<FacultyList> {
  @override
  void initState() {
    super.initState();
  }

  Widget _teacherList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ).hP16,
          getteacherWidgetList()
        ],
      ),
    );
  }

  static Stream<List<TeacherModel>> _getTeacherData() {
    final teacherDataList = FirebaseFirestore.instance
        .collection("teachers")
        .where('dept', isEqualTo: dep);
    return teacherDataList.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => TeacherModel.fromSnapshot(e)).toList());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: new Text(
            dep,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          elevation: 0,
        ),
        body: CustomScrollView(slivers: <Widget>[_teacherList()]));
  }
}
