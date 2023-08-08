import 'dart:convert';
import 'package:api_tutorial_app/models/PostModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<PostModel> postList =[];// this is because we don't have array name in the json response.

  Future<List<PostModel>> getPostApi() async{
    String url = "https://jsonplaceholder.typicode.com/posts";
    final response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      postList.clear();
      //getting response is successful and valid response.
      for(Map i in data){
        postList.add(PostModel.fromJson(i));
      }
      return postList;
    }else{
      //getting response is not successfull.
      return postList;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("API Tut. app by asif taj"),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: FutureBuilder(
              // FutureBuilder wait karega jabtak uske pass koi response nahi aata, phir wo widget ko build krega.
              future: getPostApi(),
              builder: (context, snapshot) {
                  //hum check kr rhe hai ki api se koi data mila
                  if(!snapshot.hasData){
                    // jab tak data lode ho rha hai tab tak progress indicator show kro.
                    return Center(child: CircularProgressIndicator());
                  }else{
                    return ListView.builder(
                        itemCount: postList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Id:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                  Text(postList[index].id.toString(),style: TextStyle(fontSize: 14),),
                                  Text("Title:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                  Text(postList[index].title.toString(),style: TextStyle(fontSize: 14),),
                                  Text("Body",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                  Text(postList[index].body.toString(),style: TextStyle(fontSize: 14),),
                                ],
                              ),
                            ),
                          );
                        },);
                  }
                },),
          )
        ],
      ),
    );
  }
}
