import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_health/MainPage.dart';
import 'theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'IntroScreen.dart';

class SignUp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _SignUp();
  }

}

class _SignUp extends State<SignUp>{
  final key = GlobalKey<FormState>();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController name = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            Text("SIGNUP",style:  GoogleFonts.aBeeZee(fontSize: 50,fontWeight: FontWeight.w900,color: orange ),),
            SizedBox(
              height: 30,
            ),
            Form(
              key: key,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
                    child: TextFormField(
                      style: subheading,
                      controller: name,
                      validator: MinLengthValidator(1,errorText: "Name cannot be empty"),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: GoogleFonts.aBeeZee(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.grey,width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.grey,width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.red,width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.red,width: 2),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
                    child: TextFormField(
                      style: subheading,
                      controller: email,
                      validator: MultiValidator(
                        [
                          EmailValidator(errorText: "Provide Email in correct format"),
                          RequiredValidator(errorText: "Email is required field")
                        ]
                      ),
                      decoration: InputDecoration(
                        labelText: 'E-Mail',
                        labelStyle: GoogleFonts.aBeeZee(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey,width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey,width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.red,width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.red,width: 2),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 60.0),
                    child: TextFormField(
                      style: subheading,
                      controller: password,
                      validator: MinLengthValidator(8,errorText: "Password cannot be less than 8 characters"),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: GoogleFonts.aBeeZee(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.grey,width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.grey,width: 2.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.red,width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.red,width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            FlatButton(
              color: blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                if(key.currentState.validate())
                  {
                    try {
                      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: email.text,
                          password: password.text
                      );
                      await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.uid).set({
                        "email": email.text,
                        "password": password.text,
                        "name": name.text,
                        "type": prefs.getString("mode")
                      });
                      prefs.setString("type", prefs.getString("mode"));
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>IntroScreen()));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        Fluttertoast.showToast(msg: "Password too weak",backgroundColor: Colors.red);
                      } else if (e.code == 'email-already-in-use') {
                        Fluttertoast.showToast(msg: "Account with this email already exists please Log In",backgroundColor: Colors.red);
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text("SIGNUP",style: heading1),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Existing User? Log In Here!",style: subheading),
              ),
              onTap: () async {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

}