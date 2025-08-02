import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/firebase_error_handler.dart';
import '../widgets/error_message.dart';

class PastFeedbackPage extends StatefulWidget {
  const PastFeedbackPage({super.key});

  @override
  State<PastFeedbackPage> createState() => _PastFeedbackPageState();
}

class _PastFeedbackPageState extends State<PastFeedbackPage> {
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text("⚠️ You must be logged in to view feedback.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Feedback"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('feedbacks')
              .where('uid', isEqualTo: uid)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              final firebaseError = snapshot.error is FirebaseException
                  ? FirebaseErrorHandler.getMessage(
                  (snapshot.error as FirebaseException).code)
                  : "⚠️ Failed to load feedback. Please try again.";
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ErrorMessage(message: firebaseError),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("📭 No feedback submitted yet."),
              );
            }

            final feedbacks = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: feedbacks.length,
              itemBuilder: (context, index) {
                final data = feedbacks[index].data() as Map<String, dynamic>;
                final rating = data['rating'] ?? 0;
                final comment = data['comment'] ?? '';
                final timestamp = (data['timestamp'] as Timestamp?)?.toDate();

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row with stars + rating number
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (i) {
                                return Icon(
                                  i < rating
                                      ? Icons.star
                                      : Icons.star_border_rounded,
                                  color: Colors.amber[700],
                                  size: 28,
                                );
                              }),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "$rating/5",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Comment
                        if (comment.isNotEmpty)
                          Text(
                            comment,
                            style: const TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              color: Colors.black87,
                            ),
                          ),

                        const SizedBox(height: 10),
                        const Divider(),

                        // Timestamp
                        if (timestamp != null)
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text(
                                "${timestamp.toLocal()}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
