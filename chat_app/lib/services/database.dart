import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethod {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future<QuerySnapshot> getUserByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: email)
        .get();
  }

  Future<QuerySnapshot> searchUser(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("searchKey", isEqualTo: username.substring(0, 1).toUpperCase())
        .get();
  }
}
