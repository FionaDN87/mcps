import 'package:bookreview/controller/signuppage_controller.dart';
import 'package:bookreview/view/user.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget{
 

  @override
  State<StatefulWidget> createState() {
    
    return SignUpPageState();
  }

}

class SignUpPageState extends State<SignUpPage>{
  
  SignUpPageController controller;
  BuildContext context;
  var formKey = GlobalKey<FormState>();
  User user = User();
  
  void stateChanged (Function fn){
    setState(fn);
  }

  //Constructor
  SignUpPageState(){
    controller = SignUpPageController(this);
  }
  @override

  Widget build(BuildContext context) {
    this.context = context;  
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account',style: TextStyle(fontSize: 35,fontFamily: 'Modak',color: Colors.black),),
        backgroundColor: Colors.yellow,
      ),
      body: Form(
        key:formKey,
        child: ListView(
          children: <Widget>[
            TextFormField(
              initialValue: user.profilePic,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Input URL forp profile Picture',
                labelText: 'url image',
              ),
              validator: controller.validateProfilePic,
              onSaved: controller.saveProfilePic,
            ),


            TextFormField(
              initialValue: user.email,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Email (as login name)',
                labelText: 'Email',
              ),
              validator: controller.validateEmail,
              onSaved: controller.saveEmail,
            ),
            TextFormField(
              initialValue: user.password,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
              ),
              validator: controller.validatePassword,
              onSaved: controller.savePassword,
            ),
            TextFormField(
              initialValue: user.displayName,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Display name',
                labelText: 'Display name',
              ),
              validator: controller.validateDisplayName,
              onSaved: controller.saveDisplayName,
            ),
            TextFormField(
              initialValue: 'user.zip',
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Zip code',
                labelText: 'Zip code',
              ),
              validator: controller.validateZip,
              onSaved: controller.saveZip,
            ),

            RaisedButton(
              child: Text('Create Account'),
              onPressed: controller.createAccount,
            )
          ],
        ),
      ),
    );
  }

}