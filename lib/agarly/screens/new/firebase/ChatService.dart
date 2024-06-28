import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final String _messagesTable = 'messages';

  late Database _localDatabase;

  ChatService() {
    _initLocalDatabase();
  }

  Future<void> _initLocalDatabase() async {
    _localDatabase = await openDatabase(
      'chat_local_db.db',
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $_messagesTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            senderId TEXT,
            senderEmail TEXT,
            receiverId TEXT,
            message TEXT,
            timestamp INTEGER
          )
        ''');
      },
    );
  }

  Future<void> _saveMessageLocally(Message message) async {
    await _localDatabase.insert(
      _messagesTable,
      message.toMapForLocalDb(),
    );
  }

  Future<List<Message>> getLocalMessages(
      String userId, String otherUserId) async {
    List<Map<String, dynamic>> messages = await _localDatabase.rawQuery('''
      SELECT * FROM $_messagesTable
      WHERE (senderId = ? AND receiverId = ?)
      OR (senderId = ? AND receiverId = ?)
      ORDER BY timestamp ASC
    ''', [userId, otherUserId, otherUserId, userId]);

    return messages.map((map) => Message.fromLocalDbMap(map)).toList();
  }

  // Post Messages
  Future<void> sendMessage(String receiverUserId, String message) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      return; // Cannot send message if user is not logged in
    }

    final String currentUserId = currentUser.uid;
    final String? currentUserEmail = currentUser.email;
    if (currentUserEmail == null) {
      return; // Cannot send message if user email is null
    }
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverUserId,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserId, receiverUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());

    await _saveMessageLocally(newMessage);
  }

  // Get Messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    print('Fetching messages for Chat Room ID: $chatRoomId');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }

  Map<String, dynamic> toMapForLocalDb() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp.microsecondsSinceEpoch,
    };
  }

  factory Message.fromLocalDbMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      senderEmail: map['senderEmail'],
      receiverId: map['receiverId'],
      message: map['message'],
      timestamp: Timestamp.fromMicrosecondsSinceEpoch(map['timestamp']),
    );
  }
}
