import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/application_model.dart';

class ApplicationService {
  final CollectionReference _applications =
      FirebaseFirestore.instance.collection('applications');

  Future<void> submitApplication(Application application) async {
    await _applications.add(application.toMap());
  }

  Stream<List<Application>> getApplicationsForOpportunity(String opportunityId) {
    return _applications
        .where('opportunityId', isEqualTo: opportunityId)
        .orderBy('appliedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Application.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Stream<List<Application>> getApplicationsForStudent(String studentId) {
    return _applications
        .where('studentId', isEqualTo: studentId)
        .orderBy('appliedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Application.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> updateStatus(String applicationId, String newStatus) async {
    await _applications.doc(applicationId).update({'status': newStatus});
  }
}