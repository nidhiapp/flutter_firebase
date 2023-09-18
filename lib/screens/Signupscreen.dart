import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_firebase_project/screens/Loginscreen.dart';
import 'package:new_firebase_project/services/database_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _econtroller = TextEditingController();
  TextEditingController _pcontroller = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  bool isSignedUp = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future createAccount() async {
    String email = _econtroller.text;
    String password = _pcontroller.text;
    String fullName = _usernameController.text;
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user!;
      print("account created succesfully");

   //  user.updateDisplayName(displayName: fullName);
   try {
  await user.updateDisplayName(fullName);
  print("Display name updated successfully");
} catch (e) {
  print("Error updating display name: $e");
}



      await _firestore
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "name": fullName,
        "email": email,
        "password": password,
      });
    } catch (e) {
      print("Error ${e}");
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        title: Text("SignUp screen"),
      ),
      body: Form(
        key: _formkey,
        child: isSignedUp
            ? CircularProgressIndicator()
            : Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 236, 203, 191),
                  Color.fromARGB(255, 139, 182, 140),
                ])),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Image.asset(
                        "assets/images/tree.png",
                        height: 200,
                        width: 200,
                      )),
                      Text(
                        "Email",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color.fromARGB(255, 6, 79, 8)),
                      ),
                      TextFormField(
                        controller: _econtroller,
                        decoration: InputDecoration(
                            hintText: "Enter email",
                            labelText: "email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color.fromARGB(255, 6, 79, 8)),
                      ),
                      TextFormField(
                          controller: _pcontroller,
                          decoration: InputDecoration(
                              hintText: "Enter password",
                              labelText: "password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 6, 79, 8))))),
                      SizedBox(
                        height: 20,
                      ),
                      Text("User name",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color.fromARGB(255, 6, 79, 8))),
                      TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                              hintText: "Enter User Name",
                              labelText: "Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 6, 79, 8))))),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          height: 60,
                          width: 400,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color.fromARGB(255, 6, 79, 8)),
                          child: Align(
                            alignment: Alignment.center,
                            child: MaterialButton(
                              onPressed: () {
                                createAccount();
                              },
                              // () async {
                              //   var result = await createAccount(_econtroller.text,
                              //       _pcontroller.text, _usernameController.text);
                              //   if (result == true) {
                              //     print("successfully create account");
                              //   } else {
                              //     print("invalid credential");
                              //   }
                              // },
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
  // register()async{
}
