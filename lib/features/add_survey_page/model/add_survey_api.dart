import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SurveyApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getAssignedBy() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.data()?['name'] ?? 'User';
    }
    return 'User';
  }

  Future<void> saveSurvey(Map<String, dynamic> data) async {
    final user = _auth.currentUser;
    data['created_at'] = Timestamp.now();
    await _firestore.collection('users').doc(user?.uid).collection('surveys').add(data);
  }

  Future<void> updateSurvey(String docId, Map<String, dynamic> data) async {
    final user = _auth.currentUser;
    await _firestore.collection('users').doc(user?.uid).collection('surveys').doc(docId).update(data);
  }
}
