import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chatroom extends StatelessWidget {
  Map<String, dynamic>? userMap;
  String? chatRoomId;

  Chatroom({super.key, this.userMap, this.chatRoomId});

  TextEditingController _messageController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void onSendMessage() async {
    if (_messageController.text.isNotEmpty) {
      Map<String, dynamic> messageData = {
        "sendby": FirebaseAuth.instance.currentUser!.displayName,
        "message": _messageController.text,
        "time": FieldValue.serverTimestamp(),
      };
 _messageController.clear();
      await _firestore
          .collection("chatroom")
          .doc(chatRoomId)
          .collection("chats")
          .add(messageData);

     
    } else {
      print("enter some text");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(userMap!["name "]),
      ),
      body: Column(
        children: [
          Container(
            height: 500,
            color: Colors.pink,
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chatroom')
                  .doc(chatRoomId)
                  .collection("chats")
                  .orderBy('time', descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data != null) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        return Text(snapshot.data!.docs[index]['message']);
                      }));
                } else {
                  return Container(height: 100,width:300,
                    color: Colors.green,
                  );
                }
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: "message",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              IconButton(icon: Icon(Icons.send), onPressed: onSendMessage),
            ],
          ),
        ],
      ),
    );
  }
}
