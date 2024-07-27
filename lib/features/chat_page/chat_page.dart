import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../theme/theme.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();
  DateTime? _lastMessageTime; // Son mesaj gönderim zamanı

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('messages')
                      .orderBy('timestamp')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Hata: ${snapshot.error}'),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text('Henüz mesaj yok.'),
                      );
                    }
                    List<DocumentSnapshot> messages = snapshot.data!.docs;
                    int startIndex =
                        (messages.length > 20) ? messages.length - 20 : 0;

                    // Otomatik olarak en alt kısma kaydırma işlemi
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    });

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length - startIndex,
                      itemBuilder: (context, index) {
                        var message = messages[startIndex + index];
                        bool isMe = message['senderId'] ==
                            FirebaseAuth.instance.currentUser!.uid;
                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Padding(
                            padding: isMe
                                ? EdgeInsets.only(left: 80, bottom: 8, right: 8)
                                : EdgeInsets.only(
                                    right: 80, bottom: 8, left: 8),
                            child: ListTile(
                              tileColor: isMe
                                  ? AppTheme.darkAccentColor
                                  : Colors
                                      .white10, // Renkleri buradan ayarlayabilirsiniz
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              title: Text(
                                message['username'] + ' kullanıcısının mesajı',
                                style: TextStyle(
                                  color: isMe ? Colors.white : getRandomColor(),
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                message['text'],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                if (_isLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Mesajınızı buraya yazın...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _sendMessage(_messageController
                              .text); // TextField içine girilen metni gönderiyoruz
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _sendMessage(String messageText) async {
    if (messageText.trim().isEmpty) {
      // Boş mesaj gönderimini engelle
      return;
    }

    // Mesaj gönderimleri arasındaki minimum süre (örneğin 5 saniye)
    final minimumSendInterval = Duration(seconds: 5);

    // Son mesaj gönderim zamanı kontrolü
    if (_lastMessageTime != null &&
        DateTime.now().difference(_lastMessageTime!) < minimumSendInterval) {
      // Arka arkaya hızlı mesaj gönderimini engelle
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen daha yavaş mesaj gönderin.'),
        ),
      );
      return;
    }

    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Kullanıcı adını almak için Firestore'dan veriyi getir
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    String username = userSnapshot['username'];

    try {
      await FirebaseFirestore.instance.collection('messages').add({
        'senderId': userId,
        'username': username,
        'text': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear(); // Gönderilen mesajı temizle
      _lastMessageTime = DateTime.now(); // Son mesaj gönderim zamanını güncelle
    } catch (e) {
      print('Mesaj gönderme hatası: $e');
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

Color getRandomColor() {
  Random random = Random();
  int r = random.nextInt(111) + 111; // 180-255 arası kırmızı tonu
  int g = random.nextInt(111) + 111; // 180-255 arası yeşil tonu
  int b = random.nextInt(111) + 111; // 180-255 arası mavi tonu
  return Color.fromRGBO(r, g, b, 1);
}
