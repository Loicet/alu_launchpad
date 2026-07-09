class Application {
  final String id;
  final String opportunityId;
  final String opportunityTitle;
  final String startupId;
  final String studentId;
  final String studentName;
  final String resumeLink;
  final String motivationLetter;
  final String status; // 'pending', 'shortlisted', 'accepted', 'rejected'
  final DateTime appliedAt;

  Application({
    required this.id,
    required this.opportunityId,
    required this.opportunityTitle,
    required this.startupId,
    required this.studentId,
    required this.studentName,
    required this.resumeLink,
    required this.motivationLetter,
    this.status = 'pending',
    required this.appliedAt,
  });

  factory Application.fromMap(Map<String, dynamic> map, String id) {
    return Application(
      id: id,
      opportunityId: map['opportunityId'] ?? '',
      opportunityTitle: map['opportunityTitle'] ?? '',
      startupId: map['startupId'] ?? '',
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      resumeLink: map['resumeLink'] ?? '',
      motivationLetter: map['motivationLetter'] ?? '',
      status: map['status'] ?? 'pending',
      appliedAt: (map['appliedAt'] ?? DateTime.now()).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'opportunityId': opportunityId,
      'opportunityTitle': opportunityTitle,
      'startupId': startupId,
      'studentId': studentId,
      'studentName': studentName,
      'resumeLink': resumeLink,
      'motivationLetter': motivationLetter,
      'status': status,
      'appliedAt': appliedAt,
    };
  }
}