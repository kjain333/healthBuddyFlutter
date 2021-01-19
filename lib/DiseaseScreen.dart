import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_health/theme.dart';

class DiseaseScreen extends StatelessWidget{
  List<dynamic> text;
  DiseaseScreen(this.text);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(87, 114, 195,1),
      body: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                ),
                Container(
                  height: MediaQuery.of(context).size.width-100,
                  width: MediaQuery.of(context).size.width-100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('Assets/vaccineInfobg.png'),
                      fit: BoxFit.fill
                    )
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: text.map((e){
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                      child: Text(e.toString(),style: normal1,textAlign: TextAlign.center,),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        ),
    );
  }
}