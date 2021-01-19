import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_health/ChatMessages.dart';
import 'package:one_health/theme.dart';
List<String> communities = ["Doctor's Community","Cancer Patients Community","Covid-19 Patients Community","Heart Diseases Patient Community","Immunization and Vaccination","Substance Abuse","Mental Health"];
class ChatItems extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Text("CHAT COMMUNITY",style: heading1,),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            iconSize: 32,
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height/6,
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
            ),
            SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: communities.map((e){
                    return MyTile(e,context);
                  }).toList()
              ),
            )
          ],
        ),
      )
    );
  }
  Widget MyTile(String text,BuildContext context)
  {
    return GestureDetector(
      child: Column(
        children: [
          ListTile(
            title: Text(text,style: normal,),
            trailing: Icon(Icons.arrow_forward),
          ),
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey,
          )
        ],
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatMessages(text)));
      },
    );
  }
}