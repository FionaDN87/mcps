import'package:flutter/material.dart';

class MyConfirmDialog {
  static void info({
    @required BuildContext context, 
    @required String title, 
    @required String message,
    @required Function cancelReseervation,
    @required Function checkIn,
    
     }){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return Container(
                  child: AlertDialog(
            title: Text(title, style: TextStyle(color: Colors.blue, fontFamily: 'Modak', fontSize: 30),),
            content: Text(message) ,
            actions: <Widget>[
              RaisedButton(
                child: Text('Check in', style: TextStyle(color: Colors.blue, fontFamily: 'Modak', fontSize: 20),),
                color: Colors. yellow,
                onPressed: checkIn,
              ),
             
               RaisedButton(
                child: Text('Cancel reservation',style: TextStyle(color: Colors.blue, fontFamily: 'Modak', fontSize: 20),),
                color: Colors. yellow,
                onPressed: cancelReseervation,
              ),
            ],
          ),
        );
        
      },
    );
  }

  //Progress bar dialog
  static void showProgressBar(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => 
        Center (child: CircularProgressIndicator()),
    );
  }

  //Dispose Progress bar
  static void popProgressBar(BuildContext context){
    Navigator.pop(context);     
  }
}