import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:uuid/uuid.dart';

class DatePick extends StatefulWidget {
  DatePick(
    this.data, {
    Key key,
  }) : super(key: key);
  var data;
  @override
  _DatePickState createState() => _DatePickState();
}

class _DatePickState extends State<DatePick> {
  DateTime datePicked;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  submitAppointment() async {
    String useremail = FirebaseAuth.instance.currentUser.email;
    String userid = FirebaseAuth.instance.currentUser.uid;

    var teacherid = widget.data['id'];
    String id = Uuid().v1();

    var myData = {
      'id': id,
      'date': datePicked,
      'stdemail': useremail,
      'studentid': userid,
      'teacherid': teacherid
    };

    var collection = FirebaseFirestore.instance.collection('appointments');
    await collection
        .doc(id)
        .set(myData)
        .then((_) => print('Added'))
        .catchError((error) => print('Add failed: $error'));
    setState(() {
      _isLoading = false;
    });
    final snackBar = SnackBar(content: Text("Date Picked $datePicked"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _body(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            child: Text("Select Date"),
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 160, 122, 255),
              fixedSize: const Size(200, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              textStyle: TextStyle(fontSize: 20),
            ),
            onPressed: () async {
              datePicked = await DatePicker.showSimpleDatePicker(
                context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2025),
                dateFormat: "dd-MMMM-yyyy",
                locale: DateTimePickerLocale.en_us,
                looping: true,
              );
            },
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
            child: Text("Submit"),
            style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 160, 122, 255),
                fixedSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                textStyle: TextStyle(fontSize: 20)),
            onPressed: () {
              if (datePicked != null) {
                submitAppointment();
                SizedBox(
                  height: 20,
                );
                Center(child: _isLoading ? CircularProgressIndicator() : null);
                Navigator.pop(context);
                final snackBar1 = SnackBar(
                  content: Text("Request submitted $datePicked"),
                  duration: Duration(seconds: 5),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar1);
              } else {
                final snackBar2 = SnackBar(
                  content: Text("Please Select a Date"),
                  duration: Duration(seconds: 5),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pick Appointment Date'),
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: _body(context),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
