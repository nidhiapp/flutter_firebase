import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_firebase_project/screens/Signupscreen.dart';
import 'package:new_firebase_project/screens/home_screen.dart';

class LoginScrenn extends StatefulWidget {
  const LoginScrenn({super.key});

  @override
  State<LoginScrenn> createState() => _LoginScrennState();
}

class _LoginScrennState extends State<LoginScrenn> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _econtroller = TextEditingController();
  TextEditingController _pcontroller = TextEditingController();

  void logIn() async {
    String myemail = _econtroller.text;
    String mypassword = _pcontroller.text;
    bool _isloading = false;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    
    // ignore: non_constant_identifier_names
    try {
      User? user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: myemail, password: mypassword))
          .user;
      if (user != null) {
        print("succesfullly logged in");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatpageplusLogoutImplementation()));

        
        await _firestore
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser?.uid).set({

             "email": myemail,
             "password" :mypassword,
            });
      }
    } catch (e) {
      print("Error ${e}");
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 6, 79, 8),
        automaticallyImplyLeading: true,
        title: Text("Loginscreen"),
      ),
      body: Form(
        key: _formkey,
        child: Container(
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
                  validator: (value) {
                    if (value == null) {
                      print("please enter email");
                    }
                    print(null);
                  },
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
                    validator: (value) {
                      if (value == null) {
                        print("please enter password");
                      }
                      print(null);
                    },
                    controller: _pcontroller,
                    decoration: InputDecoration(
                        hintText: "Enter password",
                        labelText: "password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 6, 79, 8))))),
                Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(height: 2),
                    )),
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
                          logIn();
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) =>
                          //           ChatpageplusLogoutImplementation()
                          //     ));
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "create account?",
                      style: TextStyle(height: 2),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    MaterialButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => SignupScreen())));
                        },
                        child: Text(
                          "Signup",
                          style: TextStyle(
                              height: 2,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // login() async {}
}

