import 'package:bookreview/controller/myfirebase.dart';
import 'package:bookreview/view/mydialog.dart';
import 'package:bookreview/view/signuppage.dart';
import 'package:flutter/material.dart';

class SignUpPageController{
  SignUpPageState state;
  SignUpPageController(this.state);

String validateProfilePic(String value){
  if(value == null || !value.contains('http')){
  return 'Enter URL address for profile picture';
}
return null;
}


void saveProfilePic(String value){
  state.user.profilePic = value;
}

String validateEmail(String value){
  if(value == null || !value.contains('.')|| !value.contains('@')){
    return 'Enter valid Email address';
     }
  return null;
   }

 void saveEmail(String value){
   state.user.email = value;   
 }

 String validatePassword(String value){
   if(value == null){
     return 'Enter password';
   }
   return null;
 }

 void savePassword(String value){
   state.user.password = value;
 }

String validateDisplayName(String value){
   if(value == null || value.length <3){
     return 'Enter at least 3 characters';
   }
   return null;
 }

void saveDisplayName(String value){
  state.user.displayName = value;
}

String validateZip(String value){
  if(value == null || value.length <5 ){
    return 'Enter at least 5-digit code';
  }
  try{
    int n = int.parse(value);
    if(n<10000){
      return 'Enter 5-digit ZIP code';
    }
  }catch(e){
    return 'Enter 5-digit ZIP code';
  }
  return null;
}

void saveZip(String value){
  state.user.zip = int.parse(value);
}

void createAccount() async {
  if(!state.formKey.currentState.validate()){
    return;
  }
    state.formKey.currentState.save();

    //Try catch to avoid duplicate registration
    try{
    //Using email/password: sign up an account at Firebase
    state.user.uid = await MyFirebase.createAccount(
      email: state.user.email, 
      password: state.user.password,
      //profilePic: state.user.profilePic,
      );

    } catch(e){
      MyDialog.info(    //Display Dialog Box 
        context: state.context,
        title: 'Account creation failed',
        message: e.message != null ? e.message : e.toString(),
        action: () => Navigator.pop(state.context),
      );

      return;  //Do not proceed if account creation failed
      
    }


    //Create user profile in Firestore database
    try{
      MyFirebase.createProfile(state.user);   //Create document in User Profile
    } catch (e){
      state.user.displayName = null;
      state.user.zip = null;
      state.user.profilePic = null;
    }
      MyDialog.info(
        context: state.context,
        title: 'Account created successfully!!!',
        message: 'Your account is created with ${state.user.email}',
        action: () => Navigator.pop(state.context),
      );

  }
  
 

 }
