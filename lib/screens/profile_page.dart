import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/validators.dart';
import '../utils/firebase_error_handler.dart';
import '../widgets/error_message.dart';
import '../widgets/custom_text_field.dart';
import 'feedback_page.dart';
import 'past_feedback_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isEditingName = false;
  bool _isEditingPhone = false;
  bool _isEditingAddress = false;

  String? _errorMessage;
  bool _isUpdating = false;

  Future<void> _updateField(String field, String value) async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    setState(() {
      _isUpdating = true;
      _errorMessage = null;
    });

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        field: value,
      });

      setState(() {
        if (field == 'name') _isEditingName = false;
        if (field == 'phone') _isEditingPhone = false;
        if (field == 'address') _isEditingAddress = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ $field updated successfully")),
      );
    } on FirebaseException catch (e) {
      setState(() {
        _errorMessage = FirebaseErrorHandler.getMessage(e.code);
      });
    } catch (_) {
      setState(() {
        _errorMessage =
        "⚠️ An unexpected error occurred while updating. Please try again.";
      });
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: ErrorMessage(
                message: "⚠️ Failed to load profile. Please try again.",
              ),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No profile data found.'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;

          _nameController.text = userData['name'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
          _addressController.text = userData['address'] ?? '';

          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        child: const Icon(Icons.person,
                            size: 40, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text("User ID: ${userData['uid']}",
                        style: const TextStyle(fontSize: 14)),
                    Text("Email: ${userData['email']}",
                        style: const TextStyle(fontSize: 14)),
                    const Divider(height: 30),

                    ErrorMessage(message: _errorMessage),

                    // ✅ Name with edit icon
                    _isEditingName
                        ? Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _nameController,
                            label: "Name",
                            validator: FieldValidator.validateName,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.check,
                              color: Colors.green),
                          onPressed: () => _updateField(
                              'name', _nameController.text.trim()),
                        ),
                      ],
                    )
                        : ListTile(
                      title: Text("Name: ${userData['name']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () =>
                            setState(() => _isEditingName = true),
                      ),
                    ),

                    // ✅ Phone with edit icon
                    _isEditingPhone
                        ? Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _phoneController,
                            label: "Phone",
                            keyboardType: TextInputType.phone,
                            validator: FieldValidator.validatePhone,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.check,
                              color: Colors.green),
                          onPressed: () => _updateField(
                              'phone', _phoneController.text.trim()),
                        ),
                      ],
                    )
                        : ListTile(
                      title: Text("Phone: ${userData['phone']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () =>
                            setState(() => _isEditingPhone = true),
                      ),
                    ),

                    // ✅ Address with edit icon
                    _isEditingAddress
                        ? Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _addressController,
                            label: "Address",
                            validator: FieldValidator.validateAddress,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.check,
                              color: Colors.green),
                          onPressed: () => _updateField(
                              'address', _addressController.text.trim()),
                        ),
                      ],
                    )
                        : ListTile(
                      title: Text("Address: ${userData['address']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () =>
                            setState(() => _isEditingAddress = true),
                      ),
                    ),

                    if (_isUpdating)
                      const Center(child: CircularProgressIndicator()),

                    const SizedBox(height: 30),
                    const Divider(),
                    const Text("Feedback",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FeedbackPage(
                                serviceId: "test-service-123"),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple),
                      child: const Text("Give Feedback"),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PastFeedbackPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple),
                      child: const Text("View Past Feedback"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
