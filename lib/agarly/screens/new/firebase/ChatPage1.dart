import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/agarly/screens/new/firebase/ChatService.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ChatPage1 extends StatefulWidget {
  final String reciverUserEmail;
  final String reciverUserid;

  const ChatPage1({
    Key? key,
    required this.reciverUserEmail,
    required this.reciverUserid,
  }) : super(key: key);

  @override
  State<ChatPage1> createState() => _ChatPage1State();
}

class _ChatPage1State extends State<ChatPage1> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    // Initialize FCM
    _configureFCM();
    _initLocalNotifications();
    // Rest of your existing initState code...
  }

  void _initLocalNotifications() async {
    // Initialization code for local notifications
  }

  void _configureFCM() {
    // FCM configuration code
  }

  void SendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.reciverUserid,
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Background color
      appBar: AppBar(
        title: Text(
          widget.reciverUserEmail,
          style: TextStyle(
            color: Colors.white, // Title text color
          ),
        ),
        backgroundColor: Colors.blue, // AppBar color
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white, // Chat bubble background color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: StreamBuilder(
                stream: _chatService.getMessages(
                  widget.reciverUserid,
                  _firebaseAuth.currentUser?.uid ?? '',
                ),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No messages Yet, Start a conversation.'),
                    );
                  }

                  return ListView(
                    reverse: true,
                    children: snapshot.data!.docs
                        .map((document) => _buildMessageItem(document))
                        .toList(),
                  );
                },
              ),
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    String message = document['message'];
    bool isSentByCurrentUser =
        document['senderId'] == _firebaseAuth.currentUser!.uid;

    return Align(
      alignment:
          isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSentByCurrentUser
              ? Colors.blue
              : Colors.grey[300], // Message bubble color
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft:
                isSentByCurrentUser ? Radius.circular(23) : Radius.circular(0),
            bottomRight:
                isSentByCurrentUser ? Radius.circular(0) : Radius.circular(23),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isSentByCurrentUser
                ? Colors.white
                : Colors.black, // Message text color
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.white, // Message input background color
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Enter your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: SendMessage,
            color: Colors.blue, // Send button color
          ),
        ],
      ),
    );
  }
}
