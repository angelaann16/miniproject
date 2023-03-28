import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appointment_app/screens/datepick.dart';
import 'package:flutter_appointment_app/theme/light_color.dart';
import 'package:flutter_appointment_app/theme/text_styles.dart';
import 'package:flutter_appointment_app/theme/theme.dart';
import 'package:flutter_appointment_app/theme/extention.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailScreen extends StatefulWidget {
  //TeacherModel model;
  DetailScreen(
    this.id, {
    Key key,
    //this.model,
  }) : super(key: key);

  String id;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailScreen> {
  //TeacherModel model;
  bool _isLoading = true;
  var data;

  @override
  void initState() {
    super.initState();
    _getTeacherData();
  }

  _getTeacherData() async {
    setState(() {
      _isLoading = true;
    });

    var teacher = await FirebaseFirestore.instance
        .collection('teachers')
        .doc(widget.id)
        .get();
    setState(() {
      data = teacher.data();
      _isLoading = false;
    });
  }

  _sendingMails() async {
    var url = Uri.parse("mailto:${data['email']}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _appbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        BackButton(
          color: Theme.of(context).primaryColor,
        ),
        IconButton(
          icon: Icon(
            data['isfavourite'] ? Icons.favorite : Icons.favorite_border,
            color: data['isfavourite'] ? Colors.red : LightColor.grey,
          ),
          onPressed: () async {
            setState(() {
              data['isfavourite'] = !data['isfavourite'];
            });
            var collection = FirebaseFirestore.instance.collection('teachers');
            await collection
                .doc(widget.id)
                .update(
                    {'isfavourite': data['isfavourite']}) // <-- Updated data
                .then((_) => print('Success'))
                .catchError((error) => print('Failed: $error'));
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyles.title.copyWith(fontSize: 25).bold;
    if (AppTheme.fullWidth(context) < 393) {
      titleStyle = TextStyles.title.copyWith(fontSize: 23).bold;
    }
    return Scaffold(
      backgroundColor: LightColor.extraLightBlue,
      body: data == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              bottom: false,
              child: Stack(
                children: <Widget>[
                  Image.network(data['image']),
                  DraggableScrollableSheet(
                    maxChildSize: .8,
                    initialChildSize: .6,
                    minChildSize: .6,
                    builder: (context, scrollController) {
                      return Container(
                        height: AppTheme.fullHeight(context) * .5,
                        padding: EdgeInsets.only(
                          left: 19,
                          right: 19,
                          top: 16,
                        ), //symmetric(horizontal: 19, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          color: Colors.white,
                        ),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                title: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              data['name'],
                                              style: titleStyle,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(
                                              Icons.check_circle,
                                              size: 18,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Text(data['dept'],
                                            style: TextStyles
                                                .bodySm.subTitleColor.bold),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          data['designation'],
                                          style: TextStyles
                                              .bodySm.subTitleColor.bold,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: .3,
                                color: LightColor.grey,
                              ),
                              Text("About", style: titleStyle).vP16,
                              Text(
                                data['description'],
                                style: TextStyles.body.subTitleColor,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: LightColor.grey.withAlpha(150),
                                    ),
                                    child: Icon(
                                      Icons.call,
                                      color: Colors.white,
                                    ),
                                  ).ripple(
                                    () async {
                                      await launchUrlString(
                                          "tel:${data['phnNo']}");
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: LightColor.grey.withAlpha(150),
                                    ),
                                    child: Icon(
                                      Icons.email_rounded,
                                      color: Colors.white,
                                    ),
                                  ).ripple(
                                    () {
                                      _sendingMails();
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DatePick(data)));
                                      },
                                      child: Text(
                                        "Make an appointment",
                                        style: TextStyles.titleNormal.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ).vP16
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  _appbar(),
                ],
              ),
            ),
    );
  }
}
