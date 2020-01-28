import 'package:bookreview/controller/profilepage_controller.dart';
import 'package:bookreview/view/user.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget{
  
  final User user;
  ProfilePage(this.user);
  @override
  State<StatefulWidget> createState() {
  
    return ProfilePageState(user);
  }

}

class ProfilePageState extends State<ProfilePage>{
  ProfilePageController controller;
  BuildContext context;
  var formKey = GlobalKey<FormState>();
  User user = User();
  
  void stateChanged (Function fn){
    setState(fn);
  }

  //Constructor
  ProfilePageState(this.user){
    controller = ProfilePageController(this);

  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
    appBar: AppBar(
          title:Text('Profile',style: TextStyle(fontSize: 35,fontFamily: 'Modak'),),
          backgroundColor: Colors.green,
        ),
        body: ListView(
          key: formKey,
          children: <Widget>[

            Image.network(user.profilePic.toString()),

            Text('Display Name'),
            TextFormField(
              initialValue: user.displayName,
              validator: controller.validateDisplayName,
              onSaved: controller.saveDislayName,
            ),

             Text('Email Address'),
            TextFormField(
              initialValue: user.email,
            ),


             Text('Zip code'),
            TextFormField(
              initialValue: user.zip.toString(),
              
            ),
         /*
            RaisedButton(
              child: Text('UPDATE'),
              onPressed: controller.updateButton,
            )
          */
          ],
        ),
    );
  }
  
}

  