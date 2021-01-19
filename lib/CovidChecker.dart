import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'theme.dart';

import 'DisplayResult.dart';

class CovidCheck extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CovidCheck();
  }
}
List<String> messages = new List();
List<String> questions = ["Hello Mate! What's your age?","Your Gender?","Do you feel any of the following:\nFever?","Tiredness?","Dry-Cough?","Difficulty in breathing?","Sore throat?","Loss of smell or taste?","Nasal Congestion?","Runny Nose?","Diarrhea?","Direct contact with someone infected?"];
List<String> keys = ["Age","Gender","Fever","Tiredness","Dry-cough","Difficulty in breathing","Sore Throat","Loss of Smell or Taste","Nasal Congestion","Runny nose","Diarrhea","Direct contact with someone infected"];
List<String> sampledata = new List();
List data = new List();
List clicked = new List();
TextEditingController controller = new TextEditingController();
ScrollController scrollController = new ScrollController();
class _CovidCheck extends State<CovidCheck>{
  bool visibilty = true;
  @override
  void initState() {
    sampledata.clear();
    data.clear();
    clicked.clear();
    messages.clear();
    messages.add(questions[0]);
    super.initState();
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
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child:
                ListView(
                  reverse: true,
                  shrinkWrap: true,
                  children: messages.map((e) => MyWidget(e)).toList(),
                  controller: scrollController,
                )
            ),
          SizedBox(
            height: 30,
          ),
          Visibility(
            visible: messages.length==24?true:false,
            child: GestureDetector(
              child: Container(
                color: orange,
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text("Submit",style: subheading1,),
                ),
              ),
              onTap: () async {
                if(clicked[0]==false)
                  {
                    Fluttertoast.showToast(msg: "Please select all fields!",backgroundColor: Colors.redAccent,);
                  }
                else
                  {
                    Map<String,dynamic> json = new Map();
                    json['Age'] = messages[messages.length-2];
                    json['Male'] = data[10][0]?"1":"0";
                    for(int i=2;i<keys.length;i++)
                      {
                        json[keys[i]] = data[11-i][0]?"1":"0";
                      }
                    print(jsonEncode(json));
                    await Navigator.push(context, MaterialPageRoute(builder: (context)=>DisplayResult(jsonEncode(json))));
                    setState(() {
                      sampledata.clear();
                      data.clear();
                      clicked.clear();
                      messages.clear();
                      messages.add(questions[0]);
                      visibilty = true;
                    });
                  }
              },
            )
          ),
          Visibility(
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                          hintText: "Your Message",
                          hintStyle: normal,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(color: Colors.grey)
                          )
                      ),
                      keyboardType: TextInputType.number,
                      onTap: (){
                        scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.linear);
                      },
                      onSubmitted: (text){
                        if(text==""||text==null||int.parse(text)>100)
                          {
                            Fluttertoast.showToast(msg: "PLease Enter correct age",backgroundColor: Colors.red);
                          }
                        else
                          {
                            messages.insert(0,text);
                            messages.insert(0,questions[(messages.length/2).round()]);
                            messages.insert(0,"g");
                            sampledata.add("g");
                            data.insert(0,[false,false]);
                            clicked.insert(0, false);
                            setState(() {
                              visibilty = false;
                              controller.text = "";
                              scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.linear);
                            });
                          }
                      },
                    ),
                  ),
                )
              ],
            ),
            visible: visibilty,
          ),
        ],
      )
    );
  }
  Widget MyWidget(String text)
  {
    int index = messages.indexOf(text);
    if(text=="b11")
      {
        return Row(
          children: [
            Expanded(child: SizedBox()),
            Container(
              constraints: BoxConstraints(
                maxWidth:  MediaQuery.of(context).size.width*0.4,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30),bottomLeft: Radius.circular(30)),
                color: Color.fromRGBO(230, 230, 230, 1),
              ),
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  GestureDetector(
                    child: Row(
                      children: [
                        (data[((index)/2).round()][0])?Icon(Icons.radio_button_checked_outlined):Icon(Icons.radio_button_off_outlined),
                        SizedBox(width: 15,),
                        Text("Yes",style: normal,)
                      ],
                    ),
                    onTap: (){
                      setState(() {
                        data[((index)/2).round()][0]=true;
                        data[((index)/2).round()][1]=false;
                        clicked[0] = true;
                        scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.linear);
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    child: Row(
                      children: [
                        (data[((index)/2).round()][1])?Icon(Icons.radio_button_checked_outlined):Icon(Icons.radio_button_off_outlined),
                        SizedBox(width: 15,),
                        Text("No",style: normal,)
                      ],
                    ),
                    onTap: (){
                      setState(() {
                        data[((index)/2).round()][1]=true;
                        data[((index)/2).round()][0]=false;
                        clicked[0] = true;
                        //clicked.insert(0,true);
                        scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.linear);
                      });
                    },
                  )
                ],
              ),
            ),

          ],
        );
      }
    else if(text.contains("\n"))
      {
        return Column(
          children: [
            Row(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width*0.6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                    color: orange,
                  ),
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(10),
                  child: Text(text.split("\n").first,style: normal1,),
                ),
                Expanded(child: SizedBox())
              ],
            ),
            Row(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width*0.6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                    color: orange,
                  ),
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(10),
                  child: Text(text.split("\n").last,style: normal1,),
                ),
                Expanded(child: SizedBox())
              ],
            )
          ],
        );
      }
    else if(text.startsWith("b"))
      {
        return Row(
          children: [
            Expanded(child: SizedBox()),
            Container(
              constraints: BoxConstraints(
                maxWidth:  MediaQuery.of(context).size.width*0.4,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30),bottomLeft: Radius.circular(30)),
                color: Color.fromRGBO(230, 230, 230, 1),
              ),
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  GestureDetector(
                    child: Row(
                      children: [
                        (data[((index)/2).round()][0])?Icon(Icons.radio_button_checked_outlined):Icon(Icons.radio_button_off_outlined),
                        SizedBox(width: 15,),
                        Text("Yes",style: normal,)
                      ],
                    ),
                    onTap: (){
                      setState(() {
                        data[((index)/2).round()][0]=true;
                        data[((index)/2).round()][1]=false;
                        if(clicked[(index/2).round()]!=true&&messages.length!=23)
                        {
                          messages.insert(0,questions[(messages.length/2).round()]);
                          sampledata.add("b");
                          clicked[(index/2).round()]=true;
                          clicked.insert(0,false);
                          messages.insert(0,"b"+sampledata.length.toString());
                          data.insert(0,[false,false]);
                          scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.linear);
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    child: Row(
                      children: [
                        (data[((index)/2).round()][1])?Icon(Icons.radio_button_checked_outlined):Icon(Icons.radio_button_off_outlined),
                        SizedBox(width: 15,),
                        Text("No",style: normal,)
                      ],
                    ),
                    onTap: (){
                      setState(() {
                        data[((index)/2).round()][1]=true;
                        data[((index)/2).round()][0]=false;
                        if(clicked[(index/2).round()]!=true&&messages.length!=23)
                        {
                          messages.insert(0,questions[(messages.length/2).round()]);
                          sampledata.add("b");
                          clicked[(index/2).round()]=true;
                          clicked.insert(0,false);
                          messages.insert(0,"b"+sampledata.length.toString());
                          data.insert(0,[false,false]);
                          scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.linear);
                        }
                      });
                    },
                  )
                ],
              ),
            ),

          ],
        );
      }
     else if(text=='g')
      {
        return Row(
          children: [
            Expanded(child: SizedBox()),
            Container(
              constraints: BoxConstraints(
                maxWidth:  MediaQuery.of(context).size.width*0.4,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30),bottomLeft: Radius.circular(30)),
                color: Color.fromRGBO(230, 230, 230, 1),
              ),
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  GestureDetector(
                    child: Row(
                      children: [
                        (data[((index)/2).round()][0])?Icon(Icons.radio_button_checked_outlined):Icon(Icons.radio_button_off_outlined),
                        SizedBox(width: 15,),
                        Text("Male",style: normal,)
                      ],
                    ),
                    onTap: (){
                      setState(() {
                        data[((index)/2).round()][0]=true;
                        data[((index)/2).round()][1]=false;
                        if(clicked[(index/2).round()]!=true&&messages.length!=23)
                        {
                          messages.insert(0,questions[(messages.length/2).round()]);
                          sampledata.add("b");
                          clicked[(index/2).round()]=true;
                          clicked.insert(0,false);
                          messages.insert(0,"b"+sampledata.length.toString());
                          data.insert(0,[false,false]);
                          scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.linear);
                        }
                      });
                      },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    child: Row(
                      children: [
                        (data[((index)/2).round()][1])?Icon(Icons.radio_button_checked_outlined):Icon(Icons.radio_button_off_outlined),
                        SizedBox(width: 15,),
                        Text("Female",style: normal,)
                      ],
                    ),
                    onTap: (){
                      setState(() {
                        data[((index)/2).round()][1]=true;
                        data[((index)/2).round()][0]=false;
                        if(clicked[(index/2).round()]!=true&&messages.length!=23)
                          {
                            messages.insert(0,questions[(messages.length/2).round()]);
                            sampledata.add("b");
                            clicked[(index/2).round()]=true;
                            clicked.insert(0,false);
                            messages.insert(0,"b"+sampledata.length.toString());
                            data.insert(0,[false,false]);
                            scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.linear);
                          }
                      });
                    },
                  )
                ],
              ),
            ),

          ],
        );
      }
    else
    return (questions.contains(text))?Row(
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width*0.6,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
            color: orange,
          ),
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(10),
          child: Text(text,style: normal1,),
        ),
        Expanded(child: SizedBox())
      ],
    ):Row(
      children: [
        Expanded(child: SizedBox()),
        Container(
          constraints: BoxConstraints(
            maxWidth:  MediaQuery.of(context).size.width*0.6,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30),bottomLeft: Radius.circular(30)),
            color: Color.fromRGBO(230, 230, 230, 1),
          ),
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(10),
          child: Text(text,style: normal,),
        ),

      ],
    );
  }
}
