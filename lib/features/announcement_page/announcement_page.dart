import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../theme/theme.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot>> _getAnnouncements() async {
    QuerySnapshot snapshot = await _firestore.collection('announcements').get();
    return snapshot.docs;
  }

  void _showMessageDialog(BuildContext context, String topic, String message) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              topic,
              style: const TextStyle(
                color: AppTheme.AccentColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            content: Text(
              message,
              style: const TextStyle(fontSize: 16.0),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OKAY',
                  style: TextStyle(color: AppTheme.AccentColor, fontSize: 18),
                ),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppTheme.TextColorWhite,
            title: Text(
              topic,
              style: const TextStyle(
                color: AppTheme.AccentColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            content: Text(
              message,
              style: const TextStyle(fontSize: 16.0),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OKAY',
                  style: TextStyle(color: AppTheme.AccentColor, fontSize: 18),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.BackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.AccentColor,
        foregroundColor: AppTheme.TextColorWhite,
        title: const Text("Announcements"),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _getAnnouncements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No notifications available."),
            );
          }

          final announcements = snapshot.data!;

          return ListView.builder(
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              var announcement = announcements[index];
              var topic = announcement['topic'] ?? 'No Title';
              var message = announcement['message'] ?? 'No Message';

              return Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                child: ListTile(
                  title: Text(
                    topic,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: AppTheme.AccentColor,
                    ),
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: AppTheme.AccentColor,
                    child: Icon(Icons.notifications,
                        color: AppTheme.TextColorWhite),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.AccentColor,
                  ),
                  onTap: () {
                    _showMessageDialog(context, topic, message);
                  },
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side:
                        const BorderSide(color: Colors.transparent, width: 0.5),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
