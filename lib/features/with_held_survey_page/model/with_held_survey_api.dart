import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WithheldSurveyApi {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getWithheldSurveysStream() {
    final user = _auth.currentUser;
    return _firestore
        .collection('users')
        .doc(user?.uid)
        .collection('withheld_surveys')
        .orderBy('created_at', descending: true)
        .snapshots();
  }
}
