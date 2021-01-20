import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadDocuments extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _UploadDocuments();
  }
}
List<String> images = new List();
bool loading =true;
class _UploadDocuments extends State<UploadDocuments>{
  User user = FirebaseAuth.instance.currentUser;
  Future<void> getDataofDocuments() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("documents").doc(user.uid).get();
    if(documentSnapshot.data()!=null)
    if(documentSnapshot.data().containsKey('images'))
      {
        List<dynamic> imageData = documentSnapshot.get('images');
        for(int i=0;i<imageData.length;i++)
        {
          images.add(imageData[i].toString());
        }
      }
    setState(() {
      loading = false;
    });
  }
  @override
  void initState() {
    images = new List();
    loading = true;
    getDataofDocuments();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                    content: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Uploading File ... "),
                      ],
                    )
                );
              }
          );
          String result = await sendDocument(user.uid);
          if(result == null)
          {
            Navigator.pop(context);
            Fluttertoast.showToast(msg: "Image not added please select an image");
          }
          else
          {

            DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("documents").doc(user.uid).get();
            List<dynamic> documents = snapshot.data()==null?null:snapshot.data()['images'];
            if(documents==null)
              documents = new List();
            documents.add(result);
            FirebaseFirestore.instance.collection("documents").doc(user.uid).set({
              'images': documents
            });
            Navigator.pop(context);
            Fluttertoast.showToast(msg: "Image added successfully");
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setDouble("score", 1.0);
            setState(() {
              images.add(result);
            });
          }
        },
      ),
      body: (loading)?Center(
        child: CircularProgressIndicator()
      ):Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0,vertical: 50.0),
        child: SingleChildScrollView(
          child: Wrap(
            children: images.map((e){
              return GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(5),
                  height: (MediaQuery.of(context).size.width-60)/3,
                  width: (MediaQuery.of(context).size.width-60)/3,
                  child: Image.network(e,
                    fit: BoxFit.fill,
                    errorBuilder: (context,object,trace){
                      return Center(
                        child: Icon(Icons.warning_rounded,color: Colors.red,size: 50,),
                      );
                    },
                  ),
                ),
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          content: Image.network(e,
                            fit: BoxFit.fitWidth,
                            errorBuilder: (context,object,trace){
                              return Center(
                                child: Icon(Icons.warning_rounded,color: Colors.red,size: 50,),
                              );
                            },
                          ),
                        );
                      }
                  );
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

}
Future<String> sendDocument(String id,{String path}) async {
  File documentToUpload;
  if(path==null)
    documentToUpload = await documentSender();
  else
  {
    documentToUpload = new File(path);
  }
  if(documentToUpload==null)
    return null;
  else
  {
    String message = await uploadFile(id,documentToUpload);
    if(message==null)
      return null;
    else
    {
      int documentSize = await documentToUpload.length();
      return message;
    }
  }
}

Future<File> documentSender(){
  return FilePicker.getFile();
}

Future<String> uploadFile(id,documentFile) async {
  String imageUrl;
  String fileName = id+DateTime.now().millisecondsSinceEpoch.toString();
  Reference reference = FirebaseStorage.instance.ref().child(fileName);
  await reference.putFile(documentFile).then((storageTaskSnapshot) async {
    await storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl){
      imageUrl = downloadUrl;
      print(downloadUrl);
    },onError: (err){
      print(err.toString());
    });
  },onError: (err){
    print("error");
  });
  return imageUrl;
}