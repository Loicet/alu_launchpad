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
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs
              .map((doc) => Application.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .toList();
          list.sort((a, b) => b.appliedAt.compareTo(a.appliedAt));
          return list;
        });
  }

  Stream<List<Application>> getApplicationsForStudent(String studentId) {
    return _applications
        .where('studentId', isEqualTo: studentId)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs
              .map((doc) => Application.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .toList();
          list.sort((a, b) => b.appliedAt.compareTo(a.appliedAt));
          return list;
        });
  }

  Future<void> updateStatus(String applicationId, String newStatus) async {
    await _applications.doc(applicationId).update({'status': newStatus});
  }
}