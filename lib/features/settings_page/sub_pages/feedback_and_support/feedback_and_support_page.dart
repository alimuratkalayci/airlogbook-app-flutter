import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coin_go/theme/theme.dart';
import 'package:intl/intl.dart';

import '../../../../general_components/custom_modal_bottom_sheet_alert_dialog/custom_modal_bottom_sheet.dart';

class FeedbackAndSupportPage extends StatefulWidget {
  @override
  _FeedbackAndSupportPageState createState() => _FeedbackAndSupportPageState();
}

class _FeedbackAndSupportPageState extends State<FeedbackAndSupportPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  InputDecoration customInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: AppTheme.TextColorWhite,
      ),
      hintText: 'Enter $labelText',
      hintStyle: TextStyle(
        color: AppTheme.TextColorWhite,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: AppTheme.TextColorWhite,
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: AppTheme.TextColorWhite,
          width: 2.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: AppTheme.Green,
          width: 2.0,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    );
  }

  Future<void> _submitFeedback() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      try {
        User? user = _auth.currentUser;
        String? userEmail = user?.email;
        String userId = user?.uid ?? '';

        String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

        final feedbackSnapshot = await _firestore
            .collection('feedback')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (feedbackSnapshot.docs.isNotEmpty) {
          Timestamp lastFeedbackTimestamp =
              feedbackSnapshot.docs.first['timestamp'];
          DateTime lastFeedbackDate = lastFeedbackTimestamp.toDate();
          String lastFeedbackDay =
              DateFormat('yyyy-MM-dd').format(lastFeedbackDate);

          if (lastFeedbackDay == today) {
            showCustomModal(
                context: context,
                title: 'Warning',
                message: 'You can only send feedback once per day.');
            setState(() {
              isLoading = false;
            });
            return;
          }
        }

        final feedbackData = {
          'name': _nameController.text,
          'email': userEmail,
          'message': _messageController.text,
          'userId': userId,
          'timestamp': Timestamp.now(),
        };

        await _firestore.collection('feedback').add(feedbackData);

        showCustomModal(
            context: context,
            title: 'Feedback Submitted',
            message: 'Your input helps us improve. Thank you!');

        _nameController.clear();
        _messageController.clear();
      } catch (e) {
        showCustomModal(
          context: context,
          title: 'Oops, Something Went Wrong',
          message: 'There was an issue submitting your feedback. Please try again later.',
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.BackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.AccentColor,
        foregroundColor: AppTheme.TextColorWhite,
        title: Text('Feedback and Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
                  child: Text(
                    'We value your feedback! If you have any questions, suggestions, or issues, please let us know by sending us a message below.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                    color: AppTheme.AccentColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            style: TextStyle(color: AppTheme.TextColorWhite),
                            decoration:
                                customInputDecoration('Name (optional)'),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _messageController,
                            style: TextStyle(color: AppTheme.TextColorWhite),
                            decoration:
                                customInputDecoration('Message (required)'),
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a message';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : _submitFeedback,
                        child: isLoading
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.TextColorWhite),
                              )
                            : Text(
                                'Send Feedback',
                                style:
                                    TextStyle(color: AppTheme.TextColorWhite),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.AccentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
