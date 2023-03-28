import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String role;
  final String username;
  final String phnNo;

  UserModel({this.username, this.role, this.phnNo, this.id});

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      username: snapshot['username'],
      role: snapshot['role'],
      phnNo: snapshot['phnNo'],
      id: snapshot['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        "role": role,
        "username": username,
        "phnNo": phnNo,
        "id": id,
      };
}
