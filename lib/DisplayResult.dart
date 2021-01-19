import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'theme.dart';
import 'package:http/http.dart' as http;

class DisplayResult extends StatefulWidget{
  String json;
  DisplayResult(this.json);
  @override
  State<StatefulWidget> createState() {
    return _DisplayResult(json);
  }
}
class _DisplayResult extends State<DisplayResult> with SingleTickerProviderStateMixin{
  double value = 0;
  double opacity = 0.0;
  bool loading = true;
  AnimationController controller;
  Animation<double> animation;
  String json;
  _DisplayResult(this.json);
  Future<String> getDataFromAPI() async{
      http.Response response = await http.post("http://10.0.0.11:3000/one_health",body: jsonDecode(json));
      print(response.body);
      if(response.statusCode==200)
        {
          var json = jsonDecode(response.body);
          return json['value'].toString();
        }
      else
        return null;
  }
  @override
  void initState() {
    controller = AnimationController(vsync: this,duration: Duration(seconds: 4));
    animation = Tween<double>(begin: 0.0,end: 1.0).animate(controller);
    getDataFromAPI().then((data){
      if(data==null)
        {
          data = "0";
          Fluttertoast.showToast(msg: "There is some error connecting to API please check your internet!");
        }
      setState(() {
        loading = false;
      });
      Future.delayed(Duration(seconds: 1),(){
        setState(() {
          value = double.parse(data);
          controller.forward();
        });
      });
      Future.delayed(Duration(seconds: 5),(){
        setState(() {
          opacity = 1.0;
        });
      });  
    }).catchError((err){
      print(err);
    });
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          iconSize: 32,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("HEALTH BUDDY",style: heading1,),
        backgroundColor: orange,
        elevation: 0,
      ),
      body: (loading==true)?Center(
        child: CircularProgressIndicator(),
      ):AnimatedBuilder(
        animation: animation,
        builder: (context,child){
          return  SingleChildScrollView(
            child:Column(
              children: [
                SizedBox(
                  height: 80,
                ),
                Stack(
                  children: [
                    Center(
                      child: AnimatedContainer(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (animation.value*value==0)?Colors.lightGreenAccent:animation.value*value<0.33?Color.fromRGBO(	105, 179, 76,1):(animation.value*value<0.66)?Color.fromRGBO(255, 141, 22,1):Color.fromRGBO(255, 17, 12,1),
                          ),
                          duration: Duration(seconds: 2),
                          curve: Curves.fastOutSlowIn,
                          child: Center(
                            child: Text((animation.value*100*value).round().toString()+"%",style: heading1,),
                          ),
                      ),
                    ),
                    Center(
                      child: AnimatedContainer(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                        duration: Duration(seconds: 6),
                        curve: Curves.fastOutSlowIn,
                        child: Opacity(
                            opacity: 0.5,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                value: animation.value*value,
                              ),
                            )
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                  child: AnimatedOpacity(
                    opacity: opacity,
                    child: Text("The probability of you being covid positive is: "+(value*100).round().toString()+"%",style: subheading,textAlign: TextAlign.center,),
                    duration: Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn,
                  ),
                )
              ],
            ),
          );
        },
      )
    );
  }
}