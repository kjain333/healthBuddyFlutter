import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
class Reminders extends StatefulWidget{
  _Reminders createState() => _Reminders();
}
DateTime now = DateTime.now();
DateTime date=DateTime(now.year,now.month,now.day);
int length=0;
Map<DateTime, List> _events={};
int ctr=0;
bool loading = true;
class _Reminders extends State<Reminders> with TickerProviderStateMixin{

  List selectedevent;
  AnimationController _animationController;
  CalendarController _calendarController;
  TextEditingController controller;
  DateTime _selectedDay;
  Future<void> initialiseEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("reminders");
    _events = jsonDecode(data);
    setState(() {
      loading = false;
    });
  }
  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    loading = true;
    initialiseEvents();
    // date = DateTime.now();
    selectedevent = _events[_selectedDay]??[];
    _calendarController = CalendarController();
    controller = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();

  }
  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    controller.dispose();
    super.dispose();
  }
  List<bool> values;
  void _onDaySelected(DateTime day,List events,List holidays){
    setState(() {
      _selectedDay = day;
      selectedevent = events;
      length = events.length;
      values = new List(length); //important to initialize with backend
      for(int i=0;i<length;i++)
      {
        values[i]=false;
      }
    });
  }
  void _onVisibleDaysChanged(DateTime first,DateTime last,CalendarFormat format){

  }
  void _onCalendarCreated(DateTime first,DateTime last,CalendarFormat format){

  }
  Widget _buildTableCalendar(){
    return StatefulBuilder(
      builder: (context,setState){
        return TableCalendar(
          calendarController: _calendarController,
          events: _events,
          startingDayOfWeek: StartingDayOfWeek.monday,
          formatAnimation: FormatAnimation.slide,
          availableGestures: AvailableGestures.all,
          initialCalendarFormat: CalendarFormat.month,
          availableCalendarFormats: const{
            CalendarFormat.month: '',
          },
          calendarStyle: CalendarStyle(
            selectedColor: Colors.orange,
            todayColor: Colors.redAccent,
            markersColor: Colors.brown,
            outsideDaysVisible: true,
          ),
          headerStyle: HeaderStyle(
            titleTextStyle: GoogleFonts.aBeeZee(fontSize: 20,color: Colors.redAccent),
            formatButtonTextStyle: GoogleFonts.aBeeZee(fontSize: 15,color: Colors.white),
            formatButtonDecoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(16)
            ),
          ),
          onDaySelected: _onDaySelected,
          onVisibleDaysChanged: _onVisibleDaysChanged,
          onCalendarCreated: _onCalendarCreated,
        );
      },
    );
  }
  Widget _buildEventList(){
    return ListView.builder(
        itemCount: selectedevent.length,
        itemBuilder: (context,index){
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
            child: ListTile(
              title: Text(selectedevent[index].toString(),style: GoogleFonts.aBeeZee(fontSize: 18,fontWeight: FontWeight.w300),),
              subtitle: Container(height: 1,color: Colors.grey.shade300,),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: StatefulBuilder(
        builder: (context,setState){
          return FloatingActionButton(
            child: Icon(Icons.add,color: Colors.white,),
            onPressed: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return StatefulBuilder(
                      builder: (context,setState){
                        return Scaffold(
                          backgroundColor: Colors.transparent,
                          body: Center(
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                      height: 300,
                                      width: 250,
                                      color: Colors.lightBlueAccent,
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "Enter a Reminder",style: GoogleFonts.aBeeZee(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w300),
                                        ),
                                      )
                                  ),
                                  Positioned(
                                    top: 50,
                                    child: Container(
                                      height: 250,
                                      width: 250,
                                      color: Colors.white,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: 50,
                                            width: MediaQuery.of(context).size.width-60,
                                            child: ListTile(
                                              title: Text(date.day.toString()+'/'+date.month.toString()+'/'+date.year.toString(),style: GoogleFonts.aBeeZee(color: Colors.lightBlueAccent,fontSize: 18),),
                                              trailing: IconButton(
                                                icon: Icon(Icons.calendar_today,color: Colors.lightBlueAccent),
                                                onPressed: () async {
                                                  final DateTime picked = await showDatePicker(
                                                    context: context,
                                                    initialDate: date,
                                                    firstDate: date,
                                                    lastDate: DateTime(date.year+1),


                                                  );
                                                  if(picked!=null)
                                                  {
                                                    setState(() {
                                                      date = picked;
                                                    });
                                                  }
                                                  else
                                                  {
                                                    setState(() {
                                                      DateTime now = DateTime.now();
                                                      date=DateTime(now.year,now.month,now.day);
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: TextField(
                                              maxLines: 3,
                                              controller: controller,
                                              style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w200,fontSize: 15),
                                              decoration: InputDecoration(
                                                  hintText: 'Enter Note Description',
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.lightBlueAccent),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.black),
                                                  )
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(18),
                                            child: RaisedButton(
                                              onPressed: () async {
                                                if(date==null)
                                                {
                                                  DateTime now = DateTime.now();
                                                  date=DateTime(now.year,now.month,now.day);
                                                }
                                                date = DateTime(date.year,date.month,date.day);

                                                if(_events.containsKey(date))
                                                {
                                                  _events.update(date, (value) => value+[controller.text]);
                                                }
                                                else
                                                  _events.addAll({date:[controller.text]});
                                                print(controller.text);
                                                print(date);
                                                controller.clear();
                                                date=DateTime.now();
                                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                                prefs.setString("reminders", jsonEncode(_events));
                                                // controller.dispose();
                                                Navigator.pop(context);
                                                setState(() {
                                                  print(_selectedDay);
                                                  _selectedDay=DateTime(_selectedDay.year,_selectedDay.month,_selectedDay.day);
                                                  if(_events[_selectedDay].toString()!="null")
                                                    _onDaySelected(_selectedDay, _events[_selectedDay],null);
                                                });
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              color: Colors.redAccent,
                                              child: Text('Add',style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15),),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                          ),
                        );
                      },
                    );
                  }
              );
            },
          );
        },
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          StatefulBuilder(
            builder: (context,setState){
              return _buildTableCalendar();
            },
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(left: 10,bottom: 5),
              child: Text('Reminders',style: GoogleFonts.aBeeZee(color: Colors.redAccent,fontSize: 18,fontWeight: FontWeight.w300),),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: Colors.grey.shade300,
          ),
          StatefulBuilder(
            builder: (context,setState){
              return Expanded(
                child: _buildEventList(),
              );
            },
          )
        ],
      ),
    );
  }

}