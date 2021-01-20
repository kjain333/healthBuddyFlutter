import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'IntroScreen.dart';
import 'SignUp.dart';
class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Login();
  }

}

class _Login extends State<Login>{
  final key = GlobalKey<FormState>();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            children: [
              SizedBox(
                height: 70,
              ),
              Text("LOGIN",style:  GoogleFonts.aBeeZee(fontSize: 50,fontWeight: FontWeight.w900,color: orange ),),
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
                          labelStyle:  GoogleFonts.aBeeZee(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.grey),
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
                        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email.text,
                            password: password.text
                        );
                        DocumentSnapshot document = await FirebaseFirestore.instance.collection("users").doc(userCredential.user.uid).get();
                        if(document.get('type')==prefs.getString("mode"))
                          {
                            prefs.setString("type", prefs.getString("mode"));
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>IntroScreen()));
                          }
                        else
                          {
                            Fluttertoast.showToast(msg: "User with this email not found please sign up",backgroundColor: Colors.red);
                          }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          Fluttertoast.showToast(msg: "User with this email not found please sign up",backgroundColor: Colors.red);
                        } else if (e.code == 'wrong-password') {
                          Fluttertoast.showToast(msg: "Wrong password please try again",backgroundColor: Colors.red);
                        }
                      }
                    }

                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("LOGIN",style: heading1),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                color: blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String result = await Navigator.push(context, MaterialPageRoute(builder: (context)=>WebViewExample("https://drchrono.com/o/authorize/?redirect_uri=https://kshitij-arora.github.io/HealthBuddy/&response_type=code&client_id=HGgz65aoFqGieLTRKjcJsIgEJJMpwvtOrpqwTBfN")));
                  if(result==null)
                    {
                      Fluttertoast.showToast(msg: "Please Log in with Dr. Chrono");
                    }
                  else
                    {
                      print(result);
                      prefs.setString("access-token", result);
                      prefs.setString("type", prefs.getString("mode"));
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>IntroScreen()));
                    }
                  },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("LOGIN WITH DR. CHRONO",style: heading1),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("New User? Sign Up Here!",style: subheading),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                },
              )
            ],
        ),
      ),
    );
  }

}
class WebViewExample extends StatefulWidget {
  String authUrl;
  WebViewExample(this.authUrl);
  @override
  WebViewExampleState createState() => WebViewExampleState(authUrl);
}

class WebViewExampleState extends State<WebViewExample> {
  String authUrl;
  WebViewExampleState(this.authUrl);
  WebViewController controllerGlobal;
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text("Health Buddy",style: TextStyle(fontSize: 25),),
            leading: IconButton(
              icon: Icon(Icons.arrow_back,size: 25,color: Colors.white,),
              onPressed: (){
                Navigator.pop(context,null);
              },
            ),
          ),
          body: Column(
            children: [

              Expanded(
                child: WebView(
                  initialUrl: authUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                  javascriptChannels: Set.from([
                    JavascriptChannel(
                        name: 'Print',
                        onMessageReceived: (JavascriptMessage message) {
                          //This is where you receive message from
                          //javascript code and handle in Flutter/Dart
                          //like here, the message is just being printed
                          //in Run/LogCat window of android studio
                          print(message.message + " javascript");
                        })
                  ]),
                  onWebViewCreated:
                      (WebViewController webViewController) {
                    _controller.complete(webViewController);
                    controllerGlobal = webViewController;
                  },
                  onPageStarted: (text){
                    print("started");
                    print(text);
                    if(text.startsWith("https://kshitij-arora.github.io/HealthBuddy/"))
                      {
                        Navigator.pop(context,text.split("=").last);
                      }
                  },
                  onPageFinished: (text){
                    print("ended");
                  },
                ),
              )
            ],
          ),
        ),
        onWillPop: (){
          Navigator.pop(context,null);
          return Future.value(true);
        });
  }
}