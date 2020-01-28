import 'package:bookreview/controller/homepage_controller.dart';
import 'package:bookreview/model/book.dart';
import 'package:bookreview/model/parking_space.dart';
import 'package:bookreview/view/user.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{

//User object and constructor 
//Since user is transfer from FrontPage to HomePage
final User user;
final List<Space> spaceList;
//Constructor
HomePage(this.user,this.spaceList);


  @override
  State<StatefulWidget> createState() {
    
    return HomePageState(user,spaceList);
  }

}

class HomePageState extends State<HomePage>{
  //User object 
  User user;
  List<Book> booklist;
  List<Space> spaceList;
  HomePageController controller;
  BuildContext context;

  List<int> deleteIndices;   //fore delete books
  List<int> slotIndex;
  HomePageState(this.user,this.spaceList){
    controller = HomePageController(this);
  }

  void stateChanged(Function fn){
    setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return WillPopScope(   //Disable return button on Android
          onWillPop: (){return Future.value(false);},
          child: Scaffold(
        appBar: AppBar(
          title: Text('HomePage',style: TextStyle(fontSize: 45,fontFamily: 'Modak',color: Colors.blue),),
          backgroundColor: Colors.yellow,
          actions: deleteIndices == null ? null :<Widget>[
            FlatButton.icon(
              label: Text('Delete'),
              icon: Icon(Icons.delete),
              onPressed: controller.deleteButton,
            )
          ],

        ),
       
        //Create DRAWER to replace return button on HOME PAGE
        drawer: Drawer(
          child: ListView(
            
            children: <Widget>[
              
            
               UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: (user.profilePic == '' || user.profilePic == null || user.profilePic.isEmpty) ? Text('No Image') : Text(''),
                  backgroundImage: (user.profilePic == '' || user.profilePic == null || user.profilePic.isEmpty) ? null : NetworkImage(user.profilePic),
                ),
                accountName: Text(user.displayName,style: TextStyle(fontSize: 20,fontFamily: 'Modak',color: Colors.blue),),
                accountEmail: Text(user.email,style: TextStyle(fontSize: 20,fontFamily: 'Modak',color:Colors.blue),),
                decoration: BoxDecoration(color: Colors.yellow),
              ),
              
               ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('Profile'),
                onTap: controller.profileButton,

              ),
              
              ListTile(
                leading: Icon(Icons.local_parking),
                title: Text('Current status'),
                onTap: controller.currentStatus,

              ),
              ListTile(
                leading: Icon(Icons.map),
                title: Text('Find a UCO Parking Space'),
                onTap: controller.mapButton,

              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                onTap: controller.signOut,
              ),    //Special Widget for Drawer

            ],
          )
        ),

         
        //body: Text('# of books = ${booklist.length}     ${user.email}   ${user.displayName}' ),
        body: Column(
          children: <Widget>[
          //VIEW MAP button
          Container(
            padding: EdgeInsets.all(5),
            child: RaisedButton(
            child: Image.asset('assets/images/view.png'),
            elevation: 0.0,
            splashColor: Colors.white,
            onPressed: controller.viewMap,
        ),
          ),

          //IMAGE BUTTONS
          //BOOK A NEW SERVICE PARKING LOT
          Container(
            padding: EdgeInsets.all(5),
            child: RaisedButton(
            child: Image.asset('assets/images/Reserve.png'),
            elevation: 0.0,
            splashColor: Colors.white,
            onPressed: controller.bookService,
        ),
          ),
          //Text('# of space = ${spaceList.length.toString()}'),  //Debug
          ],
        ),
      
        
      
      ),
    );
  }
}




