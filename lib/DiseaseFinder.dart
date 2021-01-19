import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:one_health/DiseaseScreen.dart';
import 'theme.dart';
import 'package:http/http.dart' as http;

class DiseaseFinder extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _DiseaseFinder();
  }
}
List<String> messages = new List();
List<String> diseases = [
  "itching",
  "skin_rash",
  "nodal_skin_eruptions",
  "continuous_sneezing",
  "shivering",
  "chills",
  "joint_pain",
  "stomach_pain",
  "acidity",
  "ulcers_on_tongue",
  "muscle_wasting",
  "vomiting",
  "burning_micturition",
  "spotting_urination",
  "fatigue",
  "weight_gain",
  "anxiety",
  "cold_hands_and_feets",
  "mood_swings",
  "weight_loss",
  "restlessness",
  "lethargy",
  "patches_in_throat",
  "irregular_sugar_level",
  "cough",
  "high_fever",
  "sunken_eyes",
  "breathlessness",
  "sweating",
  "dehydration",
  "indigestion",
  "headache",
  "yellowish_skin",
  "dark_urine",
  "nausea",
  "loss_of_appetite",
  "pain_behind_the_eyes",
  "back_pain",
  "constipation",
  "abdominal_pain",
  "diarrhoea",
  "mild_fever",
  "yellow_urine",
  "yellowing_of_eyes",
  "acute_liver_failure",
  "fluid_overload",
  "swelling_of_stomach",
  "swelled_lymph_nodes",
  "malaise",
  "blurred_and_distorted_vision",
  "phlegm",
  "throat_irritation",
  "redness_of_eyes",
  "sinus_pressure",
  "runny_nose",
  "congestion",
  "chest_pain",
  "weakness_in_limbs",
  "fast_heart_rate",
  "pain_during_bowel_movements",
  "pain_in_anal_region",
  "bloody_stool",
  "irritation_in_anus",
  "neck_pain",
  "dizziness",
  "cramps",
  "bruising",
  "obesity",
  "swollen_legs",
  "swollen_blood_vessels",
  "puffy_face_and_eyes",
  "enlarged_thyroid",
  "brittle_nails",
  "swollen_extremeties",
  "excessive_hunger",
  "extra_marital_contacts",
  "drying_and_tingling_lips",
  "slurred_speech",
  "knee_pain",
  "hip_joint_pain",
  "muscle_weakness",
  "stiff_neck",
  "swelling_joints",
  "movement_stiffness",
  "spinning_movements",
  "loss_of_balance",
  "unsteadiness",
  "weakness_of_one_body_side",
  "loss_of_smell",
  "bladder_discomfort",
  "foul_smell_ofurine",
  "continuous_feel_of_urine",
  "passage_of_gases",
  "internal_itching",
  "toxic_look_(typhos)",
  "depression",
  "irritability",
  "muscle_pain",
  "altered_sensorium",
  "red_spots_over_body",
  "belly_pain",
  "abnormal_menstruation",
  "dischromic_patches",
  "watering_from_eyes",
  "increased_appetite",
  "polyuria",
  "family_history",
  "mucoid_sputum",
  "rusty_sputum",
  "lack_of_concentration",
  "visual_disturbances",
  "receiving_blood_transfusion",
  "receiving_unsterile_injections",
  "coma",
  "stomach_bleeding",
  "distention_of_abdomen",
  "history_of_alcohol_consumption",
  "fluid_overload",
  "blood_in_sputum",
  "prominent_veins_on_calf",
  "palpitations",
  "painful_walking",
  "pus_filled_pimples",
  "blackheads",
  "scurring",
  "skin_peeling",
  "silver_like_dusting",
  "small_dents_in_nails",
  "inflammatory_nails",
  "blister",
  "red_sore_around_nose",
  "yellow_crust_ooze"
];
List<String> questions = ["Hello Mate! What was the first symptom you experienced","For how many days did you experience this symptom?"];
var response1;
var response2;
bool loading = false;
String searchDisease = "";
List<String> sampledata = new List();
List data = new List();
List clicked = new List();
TextEditingController controller = new TextEditingController();
TextEditingController searchText = new TextEditingController();
ScrollController scrollController = new ScrollController();
class _DiseaseFinder extends State<DiseaseFinder>{
  bool visibilty = true;
  TextInputType textInputType = TextInputType.text;
  bool submitVisible = false;
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
        bottomNavigationBar: Visibility(
            visible: submitVisible,
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
                setState(() {
                  loading = true;
                });
                List<String> responseData = new List();
                for(int i=0;i<data.length;i++)
                  {
                    if(data[i][0]==true)
                    responseData.add(messages[i*2+1].contains("\n")?messages[i*2+1].split("\n").last:messages[i*2+1]);
                  }
                print(responseData.toString());
                http.Response response = await http.post("http://10.0.0.11:3000/result",body: {
                  'symptom': messages[messages.length-2],
                  'days': messages[messages.length-4],
                  'data': responseData.toString()
                });
                print(response.body);
                if(response.statusCode!=200)
                  Fluttertoast.showToast(msg: "Error please try later");
                else {
                  List<dynamic> responseList = jsonDecode(response.body);
                  print(responseList.toString());
                  await Navigator.push(context, MaterialPageRoute(builder: (context)=>DiseaseScreen(responseList)));
                  setState(() {
                    loading = false;
                    submitVisible = false;
                    sampledata.clear();
                    data.clear();
                    clicked.clear();
                    messages.clear();
                    messages.add(questions[0]);
                    questions = ["Hello Mate! What was the first symptom you experienced","For how many days did you experience this symptom?"];
                    visibilty = true;
                  });
                }
              },
            )
        ),
        body: (loading)?Center(
          child: CircularProgressIndicator(),
        ):Column(
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
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: GestureDetector(
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
                            ),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(color: Colors.grey)
                            ),
                          ),
                          enabled: (messages.length==1)?false:true,
                          keyboardType: textInputType,

                          onSubmitted: (text) async {
                            messages.insert(0,text);
                            setState(() {
                              loading =true;
                            });
                            http.Response response = await http.post("http://10.0.0.11:3000/additional_symptom",body: {
                              'symptom': messages[2],
                              'days': messages[0],
                            });
                            if(response.statusCode!=200)
                              Fluttertoast.showToast(msg: "Error please try later");
                            else
                              {
                                String data = response.body;
                                List<String> values = data.split(",");
                                for(int i=0;i<values.length;i++)
                                  {
                                    if(i==0) {
                                      if( messages.contains(values[i].substring(2,values[i].length-1)))
                                      continue;
                                      questions.add("Did you experience any of the following?\n"+values[i].substring(2,values[i].length-1));
                                    }
                                    else if(i==values.length-1) {
                                      if( messages.contains(values[i].substring(1,values[i].length-2)))
                                        continue;
                                      questions.add(values[i].substring(
                                          1, values[i].length - 2));
                                    }
                                    else {
                                      if( messages.contains(values[i].substring(1,values[i].length-1)))
                                        continue;
                                      questions.add(values[i].substring(
                                          1, values[i].length - 1));
                                    }
                                  }
                              }
                             messages.insert(0,questions[(messages.length/2).round()]);
                             messages.insert(0,"bool");
                             sampledata.add("bool");
                              data.insert(0,[false,false]);
                              clicked.insert(0, false);
                            setState(() {
                              loading = false;
                              visibilty = false;
                              textInputType = TextInputType.number;
                              controller.text = "";
                              //scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.linear);
                            });
                          },
                        ),
                        onTap: (){
                          if(messages.length==1)
                            {
                                print("Tap");
                                if(messages.length==1)
                                {
                                  showSearchDialog((value){
                                    Navigator.pop(context);
                                    messages.insert(0,value);
                                    messages.insert(0,questions[(messages.length/2).round()]);
                                    setState(() {
                                      textInputType = TextInputType.number;
                                      controller.text = "";
                                      scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.linear);
                                    });
                                  });
                                }
                                scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.linear);
                            }
                          else
                            return null;
                        },
                      )
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
    if(messages.length==questions.length*2&&index==0)
    {
      setState(() {
        submitVisible = true;
      });
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
    else if(text.startsWith("bool"))
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
                        sampledata.add("bool");
                        clicked[(index/2).round()]=true;
                        clicked.insert(0,false);
                        messages.insert(0,"bool"+sampledata.length.toString());
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
                        sampledata.add("bool");
                        clicked[(index/2).round()]=true;
                        clicked.insert(0,false);
                        messages.insert(0,"bool"+sampledata.length.toString());
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
  showSearchDialog(ValueChanged onChange){
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, stateSetter) {
                return SingleChildScrollView(
                  child: AlertDialog(
                    backgroundColor: Colors.transparent,
                    contentPadding: EdgeInsets.zero,
                    content: Column(
                      children: [
                        AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          content: TextField(
                            controller: searchText,
                            onChanged: (value) {
                              print(value);
                              stateSetter(() {
                                searchDisease = value;
                                print(searchDisease);
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "Search",
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent)
                                ),
                                prefixIcon: Icon(Icons.search)
                            ),
                          ),
                        ),
                        AlertDialog(
                            content: Container(
                              constraints: BoxConstraints(
                                maxHeight: 300
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: diseases.map((e) {
                                    print(searchDisease);
                                    if (e.startsWith(searchDisease))
                                      return GestureDetector(
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 10),
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width,
                                            color: Colors.white,
                                            child: Text(e, style: normal,)
                                        ),
                                        onTap: () {
                                          onChange(e);
                                        },
                                      );
                                    else
                                      return Container();
                                  }).toList(),
                                ),
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                );
              });
        }
    );
  }
}
