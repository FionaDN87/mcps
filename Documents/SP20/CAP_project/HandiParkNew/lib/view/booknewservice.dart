import 'package:bookreview/controller/booknewservice_controller.dart';
import 'package:bookreview/model/parking_space.dart';
import 'package:bookreview/view/user.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookNewService extends StatefulWidget{
  final User user;
  final List<Space> spaceList;
  
 

  //Constructor
  BookNewService(this.user,this.spaceList);

  @override
  State<StatefulWidget> createState() {
    
    return BookNewServiceState(user,spaceList);
  }
}
  class BookNewServiceState extends State<BookNewService>{
    BookNewServiceController controller;
  BuildContext context;
  var formKey = GlobalKey<FormState>();
  User user = User();
  List<Space> spaceList;
  List<String> spaceLeft;   //display number of spaces left that are available 


  void stateChanged (Function fn){
    setState(fn);
  }

  //Constructor
  BookNewServiceState(this.user, this.spaceList){
    controller = BookNewServiceController(this);
    
  }

    Space space;
    Space spaceCopy;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
     appBar: AppBar(
        title: Text('Select a service',style: TextStyle(fontSize: 25,fontFamily: 'Modak'),),   //appBar title and font
        backgroundColor: Colors.blue,   //appBar backgroud color
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: controller.backButton,   //Go to HomePage
        )
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
       
Expanded(
  child:  ListView.builder(
          itemCount: spaceList.length,
          itemBuilder: (context,index) => Container(
            padding: EdgeInsets.all(5.0),
            color:spaceList[index].status == 'Available'
            ? Colors.lime : Colors.grey,
            child: Card(
              color: Colors.lime[100],
              elevation: 10.0,   //shading effect of Card()
              child: 
              RaisedButton(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                Text(spaceList[index].parkingNumber),
                Text('Status: ' + spaceList[index].status),      
                Text('UpdatedAt:' + spaceList[index].lastUpdatedAt.toString()),
                ],
              ),
              onPressed: ()=>controller.reserveSlot(index),
              ),            
            ),
          ),
          
//Testing testing 


  
        ),
),      
        ],

      ),
      
      
  
    );
    
  }
    
  }