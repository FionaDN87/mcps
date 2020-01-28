


import 'package:bookreview/controller/myfirebase.dart';
import 'package:bookreview/model/parking_space.dart';
import 'package:bookreview/view/forgetpassword.dart';
import 'package:bookreview/view/frontpage.dart';
import 'package:bookreview/view/homepage.dart';
import 'package:bookreview/view/mydialog.dart';
import 'package:bookreview/view/signuppage.dart';
import 'package:bookreview/view/user.dart';
import 'package:flutter/material.dart';

class FrontPageController{
  FrontPageState state;
  FrontPageController(this.state);


void createAccount(){
  Navigator.push(state.context,MaterialPageRoute(
    builder: (context) => SignUpPage(),
  ));
}


String validateEmail(String value){
  if(value == null || !value.contains('.') || !value.contains('@')){
    return 'Enter valid Email Address';
  }
  return null;
}

void saveEmail(String value){
  state.user.email = value;
}


String validatePassword(String value){
  if(value.length < 6 || value == null){
    return 'Enter valid password';
  }
  return null;
}

void savePassword(String value){
  state.user.password = value;
}

void login() async {
  if(!state.formKey.currentState.validate()){
    return;
  }
  state.formKey.currentState.save();

  //Show Progress Bar animation
  MyDialog.showProgressBar(state.context);


  try{
    state.user.uid = await MyFirebase.login(
      email:state.user.email, 
      password: state.user.password);
     

    } catch (e){  
      //If error occurrs show error message
      //Dispose Progress Bar and show dialog box 
      MyDialog.popProgressBar(state.context);
      MyDialog.info(
        
        context: state.context,
        title: 'Login Error',
        message: e.message != null ? e.message: e.toString(),
        action: () => Navigator.pop(state.context),
      );
        return;  //Do not proceed if log in failed
    }
    // login success -> read user profile
    //If Login success, show success message
    //Read from database could be error, use Try Catch
     try{
       User user = await MyFirebase.readProfile(state.user.uid);
       //User user = await MyFirebase.readProfile('3Xj6Uk7xlcOILsPojyeXRgeJ5rq2');    //HACKER
       state.user.displayName = user.displayName;
       state.user.zip = user.zip;
       state.user.profilePic = user.profilePic;
     }catch(e){   //If error occurs
            //No display name and zip passed
            print ('********READPROFILE' + e.toString());
     }

   
     List<Space> spaceList;
    try{
      
      spaceList = await MyFirebase.getParkingSpace();

    }catch(e){
      
     spaceList = <Space>[];
    }


     //Navigate to user HOmePage 
      //Dispose Progress Bar before showing Success Log In Dialog Box
      MyDialog.popProgressBar(state.context);

      MyDialog.info(
        context: state.context,
        title: 'Login Success',
        message: 'Press <OK> to Navigate to User Home Page',
        action: (){
          Navigator.pop(state.context);     //Dispose dialog box
          Navigator.push(state.context,MaterialPageRoute(   //Move to HomePage
          builder: (context) => HomePage(state.user,spaceList),
        ));   //Navigate to UserHomePage
        }
        
      );
  }


   //Creativity
  void forgetPassword(){
    print('Forget Password clicked');

    //Navigate to Forget Password Page
    Navigator.push(state.context, MaterialPageRoute(
      builder: (context) => ForgetPassword(),
    ));
  }
}



