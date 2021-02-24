import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sellupadmin/db/auth.dart';
import 'package:sellupadmin/screens/admin.dart';

import 'add_product.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.white,
        leading: Icon(Icons.close, color: Colors.black,),
        title: Text(
          "Sign In",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        child: Center(
          child: FlatButton(
            color: Colors.black,
            textColor: Colors.white,
            child: Text("Sign In"),
            onPressed: (){
              Future<dynamic> user = _auth.signInAnony();
              if(user != null){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Admin()));
              } else {
                Fluttertoast.showToast(msg: "InValid");
              }
            },
          ),
        ),
      ),
    );
  }
}
