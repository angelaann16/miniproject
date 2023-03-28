import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherModel {
  final String id;
  final String role;
  final String name;
  final String phnNo;
  final String description;
  final String designation;
  bool isfavourite;
  final String image;
  final String dept;

  TeacherModel(
      {this.name,
      this.role,
      this.phnNo,
      this.id,
      this.description,
      this.designation,
      this.isfavourite,
      this.image,
      this.dept});

  factory TeacherModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return TeacherModel(
        name: snapshot['name'],
        role: snapshot['role'],
        phnNo: snapshot['phnNo'],
        id: snapshot['id'],
        description: snapshot['description'],
        designation: snapshot['designation'],
        isfavourite: snapshot['isfavourite'],
        image: snapshot['image'],
        dept: snapshot['dept']);
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "dept": dept,
        "description": description,
        "phnNo": phnNo,
        "designation": designation,
        "isfavourite": isfavourite,
        "image": image,
        "role": role
      };
}
