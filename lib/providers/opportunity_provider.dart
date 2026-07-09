import 'package:flutter/material.dart';
import '../models/opportunity_model.dart';
import '../services/opportunity_service.dart';

class OpportunityProvider extends ChangeNotifier {
  final OpportunityService _service = OpportunityService();

  Future<void> postOpportunity(Opportunity opportunity) async {
    await _service.postOpportunity(opportunity);
  }

  Stream<List<Opportunity>> get allOpportunities => _service.getOpportunities();

  Stream<List<Opportunity>> opportunitiesByStartup(String startupId) =>
      _service.getOpportunitiesByStartup(startupId);
}