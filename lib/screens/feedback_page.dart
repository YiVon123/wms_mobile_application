import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/firebase_error_handler.dart';
import '../widgets/error_message.dart';

class FeedbackPage extends StatefulWidget {
  final String serviceId;
  const FeedbackPage({super.key, required this.serviceId});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _rating = 0;
  final _commentController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  Future<void> _submitFeedback() async {
    if (_rating == 0) {
      setState(() => _errorMessage = "Please provide a star rating");
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      await FirebaseFirestore.instance.collection('feedbacks').add({
        'uid': uid,
        'serviceId': widget.serviceId,
        'rating': _rating,
        'comment': _commentController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Feedback submitted successfully!")),
      );
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      setState(() => _errorMessage = FirebaseErrorHandler.getMessage(e.code));
    } catch (_) {
      setState(() => _errorMessage = "⚠️ Could not submit feedback. Please try again.");
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rate Service"), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Rate your completed service", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return IconButton(
                  icon: Icon(i < _rating ? Icons.star : Icons.star_border, color: Colors.amber, size: 36),
                  onPressed: () => setState(() => _rating = i + 1),
                );
              }),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Leave a comment (optional)",
                border: OutlineInputBorder(),
              ),
            ),
            ErrorMessage(message: _errorMessage),
            const SizedBox(height: 20),
            _isSubmitting
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: const Text("Submit Feedback"),
            ),
          ],
        ),
      ),
    );
  }
}
