import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Authenticate {
  //Checks if anyone is logged in
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Getter of the current user's data
  User? get currentUser => _firebaseAuth.currentUser;

  //Signal if user logged in or logged out
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //For Log in
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //For Register
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    //Save the name to the Firebase profile
    if (displayName != null) {
      await credential.user?.updateDisplayName(displayName);
    }

    //Create user document in Firestore with a default role
    await _firestore.collection('users').doc(credential.user!.uid).set({
      'uid': credential.user!.uid,
      'email': email,
      'displayName': displayName,
      'role': 'user', //Default role for new sign-ups
    });
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
