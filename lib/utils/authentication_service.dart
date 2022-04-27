import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuth get auth => _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed in.";
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  Future<String> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "Signed up.";
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  Future<String> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return 'A reset link has been sent to your mail';
    } catch (e) {
      return 'Error while resetting password';
    }
  }

  Future<String> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return 'Signed out successfully.';
    } catch (e) {
      return 'Error while signing out.';
    }
  }
}
