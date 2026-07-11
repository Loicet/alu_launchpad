import 'package:cloud_firestore/cloud_firestore.dart';

class Opportunity {
  final String id;
  final String startupId;
  final String startupName;
  final String title;
  final String category; // Development, Design, Marketing, Business, etc.
  final String locationType; // Remote, On-site, Hybrid
  final String duration;
  final String description;
  final List<String> skills;
  final DateTime createdAt;

  Opportunity({
    required this.id,
    required this.startupId,
    required this.startupName,
    required this.title,
    required this.category,
    required this.locationType,
    required this.duration,
    required this.description,
    required this.skills,
    required this.createdAt,
  });

  factory Opportunity.fromMap(Map<String, dynamic> map, String id) {
    return Opportunity(
      id: id,
      startupId: map['startupId'] ?? '',
      startupName: map['startupName'] ?? '',
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      locationType: map['locationType'] ?? '',
      duration: map['duration'] ?? '',
      description: map['description'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startupId': startupId,
      'startupName': startupName,
      'title': title,
      'category': category,
      'locationType': locationType,
      'duration': duration,
      'description': description,
      'skills': skills,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}