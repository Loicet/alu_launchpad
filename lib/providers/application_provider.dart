import 'package:flutter/material.dart';
import '../models/application_model.dart';
import '../services/application_service.dart';

class ApplicationProvider extends ChangeNotifier {
  final ApplicationService _service = ApplicationService();

  Future<void> submitApplication(Application application) async {
    await _service.submitApplication(application);
  }

  Stream<List<Application>> applicationsForOpportunity(String opportunityId) =>
      _service.getApplicationsForOpportunity(opportunityId);

  Stream<List<Application>> applicationsForStudent(String studentId) =>
      _service.getApplicationsForStudent(studentId);

  Future<void> updateStatus(String applicationId, String newStatus) async {
    await _service.updateStatus(applicationId, newStatus);
    notifyListeners();
  }
}