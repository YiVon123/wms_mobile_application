class FirebaseErrorHandler {
  static String getMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return '❌ The email address is not valid.';
      case 'user-disabled':
        return '🚫 This account has been disabled.';
      case 'user-not-found':
        return '📧 This email is not registered. Please sign up first.';
      case 'wrong-password':
      case 'invalid-credential': // ✅ handle both as wrong password
        return '🔑 The password you entered is incorrect.';
      case 'email-already-in-use':
        return '📧 This email is already registered.';
      case 'weak-password':
        return '⚠️ The password is too weak.';
      case 'operation-not-allowed':
        return '⚠️ This login method is not enabled.';
      case 'unknown':
        return '⚠️ An unexpected error occurred. Please try again.';
      default:
        return '⚠️ Something went wrong. Please try again.';
    }
  }
}
