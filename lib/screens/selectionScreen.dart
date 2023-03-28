import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appointment_app/model/firestore_helper.dart';
import 'package:flutter_appointment_app/screens/teacherhome.dart';

class SelectScreen extends StatefulWidget {
  SelectScreen({
    Key key,
  }) : super(key: key);
  var data;
  @override
  _selectscreenstate createState() => _selectscreenstate();
}

// ignore: camel_case_types
class _selectscreenstate extends State<SelectScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  Future delete() async {
    _isLoading = true;
    final appointments = FirebaseFirestore.instance.collection('appointments');
    final docref = appointments.doc(selected).delete();
    _isLoading = false;
  }

  Widget _body(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Select an option:-',
            style: TextStyle(color: Colors.black45, fontSize: 30),
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
            child: Text("Accept"),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              fixedSize: const Size(200, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              textStyle: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              delete();
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Navigator.of(context).pop();
            },
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
            child: Text("Reject"),
            style: ElevatedButton.styleFrom(
                primary: Colors.red,
                fixedSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                textStyle: TextStyle(fontSize: 20)),
            onPressed: () {
              delete();
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Navigator.of(context).pop();
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
