import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScheduledSurveyApi {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getScheduledSurveysStream() {
    final user = _auth.currentUser;
    return _firestore
        .collection('users')
        .doc(user?.uid)
        .collection('surveys')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Future<void> moveToWithheldAndDelete(DocumentSnapshot doc) async {
    final user = _auth.currentUser;
    final data = doc.data() as Map<String, dynamic>;
    await _firestore
        .collection('users')
        .doc(user?.uid)
        .collection('withheld_surveys')
        .add(data);

    await _firestore
        .collection('users')
        .doc(user?.uid)
        .collection('surveys')
        .doc(doc.id)
        .delete();
  }
}
