import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_health/ChatItems.dart';
import 'package:one_health/DiseaseFinder.dart';
import 'package:one_health/Reminders.dart';
import 'theme.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CovidChecker.dart';
import 'MyDrawer.dart';

class MainPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MainPage();
  }
}
class _MainPage extends State<MainPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HEALTH BUDDY",style: heading1,),
        backgroundColor: orange,
        elevation: 0,
      ),
      drawer: buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue.shade200
                ),
                child: Column(
                  children: [
                    Center(
                      child: Icon(Icons.verified_user_sharp,color: Colors.blue,size: 60,),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("COVID CHECKER",style: subheading1,),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Have a quick look if you are covid infected or not by answering few simple questions and let the machine do the rest",style: normal1,textAlign: TextAlign.center,),
                    ),
                  ],
                ),
              ),
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>CovidCheck()));
              },
            ),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue.shade200
                ),
                child: Column(
                  children: [
                    Center(
                      child: Icon(Icons.account_circle_sharp,color: Colors.blue,size: 60,),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("DOCTORS NEAR YOU",style: subheading1,),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Got any disease? Get quick info about various doctors closest to you",style: normal1,textAlign: TextAlign.center,),
                    ),
                  ],
                ),
              ),
              onTap: (){
                launch("https://www.google.com/maps/search/?api=1&query=doctor");
              },
            ),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue.shade200
                ),
                child: Column(
                  children: [
                    Center(
                      child: Icon(Icons.chat_bubble,color: Colors.blue,size: 60,),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("COMMUNITY CHAT",style: subheading1,),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Worried about about going for a operation or taking a new medicine? Get help from experts and people who have witnessed the same",style: normal1,textAlign: TextAlign.center,),
                    ),
                  ],
                ),
              ),
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>ChatItems()));
              },
            ),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue.shade200
                ),
                child: Column(
                  children: [
                    Center(
                      child: Icon(Icons.check_circle,color: Colors.blue,size: 60,),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("DISEASE FINDER",style: subheading1,),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Have symptoms and don't if it can be deadly or not? With our disease finder tool you can check it all by answring few simple questions.",style: normal1,textAlign: TextAlign.center,),
                    ),
                  ],
                ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>DiseaseFinder()));
              },
            ),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue.shade200
                ),
                child: Column(
                  children: [
                    Center(
                      child: Icon(Icons.alarm,color: Colors.blue,size: 60,),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("REMINDERS",style: subheading1,),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Have a habit of missing out on important appointments? Don't worry we have covered it all!",style: normal1,textAlign: TextAlign.center,),
                    ),
                  ],
                ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Reminders()));
              },
            ),
          ],
        ),
      )
    );
  }

}