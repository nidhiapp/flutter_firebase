import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_firebase_project/screens/Loginscreen.dart';
import 'package:new_firebase_project/screens/Signupscreen.dart';
import 'package:new_firebase_project/screens/one_to_one_chatscreen.dart';

class ChatpageplusLogoutImplementation extends StatefulWidget {
  const ChatpageplusLogoutImplementation({super.key});

  @override
  State<ChatpageplusLogoutImplementation> createState() =>
      _ChatpageplusLogoutImplementationState();
}

class _ChatpageplusLogoutImplementationState
    extends State<ChatpageplusLogoutImplementation> {
  late Map<String, dynamic> userMap = {};
  TextEditingController _searchController = TextEditingController();

  String chatroomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void checkAuthStatus() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is signed out.');
      } else {
        print('User is signed in: ${user.uid}');
      }
    });
  }

  bool isLoading = false;
  bool isSignedOut = false;

  void signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pop(context);
      print("signedout");
    } catch (e) {
      print("Error ${e}");
    }
  }

  void onSearch() async {
    String search = _searchController.text;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection("user")
        .where("email", isEqualTo: search)
        .get()
        .then((value) {
      setState(() {
        isLoading = false;
        userMap = value.docs[0].data();
      });
      print(userMap);
    });
  }

// @override
//   void initState() {
//     super.initState();
//     getUser();
//   }

  void getUser() async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: true,
          title: Text("Talk About Nature"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? Container(
                  height: 100, width: 100, child: CircularProgressIndicator())
              : Container(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _searchController,
                        decoration: InputDecoration(
                            hintText: "search",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                          onPressed: onSearch, child: Text("Search")),
                      userMap != null
                          ? ListTile(
                              onTap: () {
                                String roomId = chatroomId(
                                    FirebaseAuth
                                        .instance.currentUser!.displayName!,
                                    userMap['name']);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Chatroom(chatRoomId: roomId,userMap: userMap,)));
                              },
                              title:
                                  Text(userMap["name"] ?? "Name not available"),
                              subtitle: Text(
                                  userMap["email"] ?? "Email not available"),
                              trailing: Icon(Icons.chat),
                            )
                          : Container(
                              height: 100,
                              width: 200,
                              color: Colors.red,
                            ),
                      SizedBox(height: 30),
                      ElevatedButton(
                          onPressed: () {
                            signOutUser();
                            checkAuthStatus();
                          },
                          child: Text("Logout"))
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
