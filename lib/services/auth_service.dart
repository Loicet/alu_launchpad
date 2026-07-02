import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream that tells the app whether someone is logged in or not, live
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  // Sign up a new user and save their profile info to Firestore
  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      AppUser newUser = AppUser(
        uid: result.user!.uid,
        email: email,
        name: name,
        role: role,
      );

      await _firestore
          .collection('users')
          .doc(result.user!.uid)
          .set(newUser.toMap());

      return null; // null means success, no error
    } on FirebaseAuthException catch (e) {
      return e.message; // return the error message to show in the UI
    }
  }

  // Log in an existing user
  Future<String?> logIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Fetch the full user profile (role, name, etc.) from Firestore
  Future<AppUser?> getUserData(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return AppUser.fromMap(doc.data() as Map<String, dynamic>, uid);
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}