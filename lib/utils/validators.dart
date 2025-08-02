class FieldValidator {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return "Enter your name";
    if (RegExp(r'\d').hasMatch(value)) return "Name cannot contain numbers";
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return "Enter your phone number";
    if (!RegExp(r'^(?:\+60|0)\d{8,10}$').hasMatch(value)) {
      return "Enter a valid Malaysian phone number (e.g. 0123456789)";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return "Enter your email";
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) return "Enter your address";
    return null;
  }
}
