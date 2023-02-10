import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Programmer {
  final String name;
  final String id;

  const Programmer(this.name, this.id);

  static Future<Programmer> ziskatProgramatora(User current, String id) async {
    if (id == current.uid) {
      return Programmer(current.displayName!, id);
    } else {
      var d = await FirebaseFirestore.instance
          .collection("users")
          .doc(current.uid)
          .collection("programmers")
          .doc(id)
          .get();
      return Programmer(d.data()!["name"], id);
    }
  }
}
