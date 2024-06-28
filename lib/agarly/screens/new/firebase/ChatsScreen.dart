import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/agarly/screens/new/firebase/ChatPage1.dart';

class chatscreenn extends StatefulWidget {
  chatscreenn({Key? key});

  @override
  State<chatscreenn> createState() => _chatscreennState();
}

class _chatscreennState extends State<chatscreenn> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue, // Set background color for the "Chat" header
            child: Row(
              children: [
                Text(
                  "Chat",
                  style: TextStyle(
                    color: Colors.white, // Set text color for the "Chat" header
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('users').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Text('Error');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No users found');
                  }

                  return Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // children: [
                        //   for (final doc in snapshot.data!.docs)
                        //     _buildUserProfilePicture(doc),
                        // ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], // Change background color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('users').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Text('Error');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No users found');
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];

                      return _buildUserListItem(doc);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildUserProfilePicture(DocumentSnapshot document) {
  //   Map<String, dynamic> data = document.data() as Map<String, dynamic>;

  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: CircleAvatar(
  //       backgroundColor: Colors.blue, // Change circle avatar background color
  //       radius: 20.0,
  //     ),
  //   );
  // }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    String firstName = data['First name'] as String? ?? 'Unknown user';
    String uid = data['uid'] as String? ?? '';
    String email = data['email'] as String? ?? '';

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Chat_rooms')
          .doc(_getChatRoomId(uid))
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        String lastMessage = 'No messages yet';

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          lastMessage = snapshot.data!.docs[0]['message'] as String? ?? '';
        }

        return ListTile(
          title: Text(firstName),
          subtitle: Text(lastMessage),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage1(
                  reciverUserEmail: email,
                  reciverUserid: uid,
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getChatRoomId(String otherUserId) {
    List<String> ids = [_firebaseAuth.currentUser!.uid, otherUserId];
    ids.sort();
    return ids.join("_");
  }
}
