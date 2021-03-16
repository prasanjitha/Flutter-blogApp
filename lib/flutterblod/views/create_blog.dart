import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:testproject/flutterblod/services/crud.dart';

class createblog extends StatefulWidget {
  @override
  _createblogState createState() => _createblogState();
}

class _createblogState extends State<createblog> {
  String autherName ,title, desc;
  File selectedImage;
  bool _isloading=false;
  CrudMethod cd=new CrudMethod();

  Future getImage() async{
    var image=await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage=image;
    });
  }
  uploadBlod()async{

    if(selectedImage!=null){
      setState(() {
        _isloading=true;
      });
      /// uploading firebase storange
      StorageReference firebasereference=FirebaseStorage.instance.ref().child("blogImages")
          .child("${randomAlphaNumeric(9)}.jpg");
      final StorageUploadTask task=firebasereference.putFile(selectedImage);
      var downloadURL=await(await task.onComplete).ref.getDownloadURL();
      print("this is url $downloadURL");
      Map<String ,String> blogMap={
        "imgurl": downloadURL,
        "authorName":autherName,
        "title":title,
        "dectription" :desc
      };
      cd.addData(blogMap).then((result){
        Navigator.pop(context);
      });
    }else{

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Flutter",style: TextStyle(fontSize: 22),),
            Text("Blog",style: TextStyle(fontSize: 22,color: Colors.blue),)
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          GestureDetector(
            onTap: (){
              uploadBlod();
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.file_upload)),
          ),

        ],
      ),
      body:_isloading? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ): Container(
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                getImage();
              },
              child: selectedImage!=null?Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(selectedImage,fit: BoxFit.cover,)),

              ): Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6)
                ),
                width: MediaQuery.of(context).size.width,
                child: Icon(Icons.add_a_photo,color: Colors.black54,),
              ),
            ),
            SizedBox(height: 8.0,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        hintText: "Author Name"
                    ),
                    onChanged: (val){
                      autherName=val;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: "Title"
                    ),
                    onChanged: (val){
                      title=val;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: "Description"
                    ),
                    onChanged: (val){
                      desc=val;
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
