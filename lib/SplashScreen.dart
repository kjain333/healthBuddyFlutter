import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'MainPage.dart';
import 'theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}
class _SplashScreen extends State<SplashScreen>{
  double visibility1 = 0;
  double visibility2 = 0;
  bool selected = true;
  bool selected2 = true;
  bool position1 = false;
  bool position2 = false;
  double visible = 0;
  String type;
  void checkForPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      type = (prefs.get("type")!=null)?prefs.getString("type"):"";
    });
  }
  @override
  void initState() {
    checkForPrefs();
    Future.delayed(Duration(milliseconds: 500),(){
      setState(() {
        selected = false;
      });
    });
    Future.delayed(Duration(milliseconds: 750),(){
      setState(() {
        selected = true;
        position1 = true;
        selected2 = false;
      });
    });
    Future.delayed(Duration(milliseconds: 1000),(){
      setState(() {
        selected2 = true;
        position2 = true;
        visibility1 = 1;
      });
    });
    Future.delayed(Duration(seconds: 1,milliseconds: 250),(){
      setState(() {
        visibility2 = 1;
      });
    });
    Future.delayed(Duration(seconds: 1,milliseconds: 500),(){
      setState(() {
        visible = 1;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("Assets/initial.gif")
                          )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: AnimatedOpacity(
                      child: Text("HealthBuddy",style: GoogleFonts.aBeeZee(fontSize: 50,fontWeight: FontWeight.w900,color: orange ),),
                      opacity: visibility1,
                      duration: Duration(milliseconds: 250),
                    )
                  ),
                  AnimatedOpacity(
                    opacity: visibility2,
                    duration: Duration(milliseconds: 250),
                    child: Text("WE CARE FOR YOU",style: GoogleFonts.aBeeZee(fontStyle: FontStyle.italic,fontSize: 20,fontWeight: FontWeight.w500,color: blue),),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: AnimatedOpacity(
                      opacity: visible,
                      duration: Duration(milliseconds: 1000),
                      child: FlatButton(
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString("mode", "doctor");
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>(type=="doctor")?MainPage():Login()));
                        },
                        color: orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("DOCTOR",style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 22),),
                        ),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: visible,
                    duration: Duration(milliseconds: 1000),
                    child: FlatButton(
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString("mode", "patient");
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>(type=="patient")?MainPage():Login()));
                      },
                      color: blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("PATIENT",style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 22),),
                      ),
                    ),
                  )
                ],
              ),

            ),
            Positioned(
              top: 300,
              left: (position1)?null:40,
              right: (position1)?40:null,
              child: AnimatedContainer(
                height: 50,
                width: (selected)?0:MediaQuery.of(context).size.width-80,
                color: orange,
                duration: Duration(milliseconds: 250),
              ),
            ),
            Positioned(
              top: 360,
              left: (position2)?null:40,
              right: (position2)?40:null,
              child: AnimatedContainer(
                height: 50,
                width: (selected2)?0:MediaQuery.of(context).size.width-80,
                color: blue,
                duration: Duration(milliseconds: 250),
              ),
            ),
          ],
        )
    );
  }

}