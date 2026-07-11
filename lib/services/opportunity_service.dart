import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/opportunity_model.dart';

class OpportunityService {
  final CollectionReference _opportunities =
      FirebaseFirestore.instance.collection('opportunities');

  // Real-time stream of all opportunities, newest first
  Stream<List<Opportunity>> getOpportunities() {
    return _opportunities
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Opportunity.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Real-time stream filtered to one startup's own postings
  Stream<List<Opportunity>> getOpportunitiesByStartup(String startupId) {
    return _opportunities
        .where('startupId', isEqualTo: startupId)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs
              .map((doc) => Opportunity.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  Future<void> postOpportunity(Opportunity opportunity) async {
    await _opportunities.add(opportunity.toMap());
  }

  Future<Opportunity?> getOpportunityById(String id) async {
    DocumentSnapshot doc = await _opportunities.doc(id).get();
    if (doc.exists) {
      return Opportunity.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }
}