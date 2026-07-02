class AppUser {
  final String uid;
  final String email;
  final String name;
  final String role; // "student" or "startup"
  final bool isVerified; // relevant for startups only

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.isVerified = false,
  });

  // Convert Firestore document into an AppUser object
  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'student',
      isVerified: map['isVerified'] ?? false,
    );
  }

  // Convert AppUser object into a Map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role,
      'isVerified': isVerified,
    };
  }
}