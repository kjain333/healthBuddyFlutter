import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_health/theme.dart';

class ChatMessages extends StatefulWidget{
  String text;
  ChatMessages(this.text);
  @override
  State<StatefulWidget> createState() {
    return _ChatMessages(text);
  }
}
List<QueryDocumentSnapshot> data = new List();
bool loading = true;
class _ChatMessages extends State<ChatMessages>{
  String text;
  _ChatMessages(this.text);
  TextEditingController controller = new TextEditingController();
  void getDataFromFirebase(){
    FirebaseFirestore.instance.collection("chat").doc(text).collection("messages").orderBy('time').get().then((value){
      data = value.docs;
      setState(() {
        loading = false;
      });
    });
  }
  @override
  void initState() {
    loading = true;
    data = new List();
    getDataFromFirebase();
    controller = new TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return (loading == true)?Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(text,style: heading1,),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          iconSize: 32,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ):Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(text,style: heading1,),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          iconSize: 32,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                  children: data.map((e){
                    return buildChatItem(e);
                  }).toList()
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400)
            ),
            constraints: BoxConstraints(
              maxHeight: 200,
            ),
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: normal,
                    minLines: null,
                    maxLines: null,
                    controller: controller,
                    decoration: InputDecoration(
                      hintStyle: normal,
                      hintText: "Type your message",
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400)
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: orange,
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.send,size: 30,),
                      color: Colors.white,
                      onPressed: (){
                        FirebaseFirestore.instance.collection("chat").doc(text).collection("messages").add({
                          'id': FirebaseAuth.instance.currentUser.uid,
                          'message': controller.text,
                          'time': DateTime.now().millisecondsSinceEpoch.toString(),
                        });
                        setState(() {
                          controller.text = "";
                          loading = true;
                        });
                        getDataFromFirebase();
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildChatItem(QueryDocumentSnapshot document)
  {
    if(document.get('id')==FirebaseAuth.instance.currentUser.uid)
      return Row(
        children: [
          Expanded(
            child: SizedBox(),
          ),
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.all(15),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width*0.6,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),bottomLeft: Radius.circular(20)),
              color: Color.fromRGBO(230, 230, 230, 1),
            ),
            child: Text(document.get('message'),style: normal,),
          )
        ],
      );
    else
      return Row(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.all(15),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width*0.6,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
              color: orange,
            ),
            child: Text(document.get('message'),style: normal1,),
          ),
          Expanded(
            child: SizedBox(),
          )
        ],
      );
  }
}