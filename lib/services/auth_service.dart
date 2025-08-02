import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/firebase_error_handler.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signup(
      String email, String password, String name, String phone, String address) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = userCredential.user!.uid;

      final newUser = UserModel(
        uid: uid,
        email: email,
        name: name,
        phone: phone,
        role: "customer",
        address: address,
      );

      await _firestore.collection('users').doc(uid).set(newUser.toMap());
      return null;
    } on FirebaseAuthException catch (e) {
      return FirebaseErrorHandler.getMessage(e.code);
    } catch (e) {
      return FirebaseErrorHandler.getMessage("unknown");
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return FirebaseErrorHandler.getMessage(e.code);
    } catch (e) {
      return FirebaseErrorHandler.getMessage("unknown");
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return FirebaseErrorHandler.getMessage(e.code);
    } catch (e) {
      return FirebaseErrorHandler.getMessage("unknown");
    }
  }
}
