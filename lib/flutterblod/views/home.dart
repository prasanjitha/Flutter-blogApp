import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testproject/flutterblod/services/crud.dart';

import 'create_blog.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethod cd=new CrudMethod();
  Stream displayStream;

  Widget Blogslist(){
    return Container(

      child:  displayStream !=null?

      Column(children: [

       StreamBuilder(
           stream: displayStream,
           builder: (context, snapshot){
             return ListView.builder(
                 padding: EdgeInsets.symmetric(horizontal: 18),
                 itemCount: snapshot.data.documents.length,
                 shrinkWrap: true,
                 itemBuilder: (context ,index){
                   return BlogsTile(
                     authorname: snapshot.data.documents[index].data['authorName'],
                     title:snapshot.data.documents[index].data['title'],
                     description: snapshot.data.documents[index].data['dectription'],
                     imgurl: snapshot.data.documents[index].data['imgurl'],
                   );
                 });
           })
      ],):
      Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),

    );
  }
  @override
  void initState() {
    // TODO: implement initState
    cd.getData().then((result){
      displayStream =result;
    });
    super.initState();
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
   ),
      body:  Blogslist(),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>createblog()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BlogsTile extends StatelessWidget {
  String imgurl ,title , description ,authorname;
  BlogsTile({@required this.imgurl,@required this.title,@required this.authorname,@required this.description});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      height: 150,
      child: Stack(
        children: [

         ClipRRect(
             borderRadius: BorderRadius.circular(6),
             child:Image.network(imgurl,fit: BoxFit.cover,
             width: MediaQuery.of(context).size.width,
             )),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500),),
                Text(description),
                Text(authorname)
              ],
            ),
          )
        ],
      ),
    );
  }
}
