
import 'package:bookreview/model/parking_space.dart';
import 'package:bookreview/view/booknewservice.dart';
import 'package:bookreview/view/homepage.dart';
import 'package:bookreview/view/mycheckoutdialog.dart';
import 'package:bookreview/view/mydialog.dart';
import 'package:bookreview/view/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookNewServiceController{
  BookNewServiceState state;
  List<Space> spacelist;   //array of parking space
  List<int> slotIndex = [];  //array to carry slot that reserves
  var spaces = <Space>[];
  String reserveSpotNumber;
  String statusFlag;
  List<String> spaceLeft;   //display number of spaces left that are available 

  User user;
  BookNewServiceController(this.state);


  void reserveSlot(int index) async{  //pass index of parking lot
  //Unavailable parking lot
  //print('${spacelist[index].status}');
  //print('$index is booked ' ); 
  if(state.spaceList[index].status == 'unavailable' 
        || state.spaceList[index].status == 'reserved' 
        || state.spaceList[index].status == 'Checked In'){
     print('Unable to reserve');
     //Show dialog to notify unable to reserve
     //Click OK on dialog box, return to booknewservice page
      MyDialog.info(
        context: state.context,
        title: 'Reservation Error!!!',
        message: 'This parking lot has been \n<< ${state.spaceList[index].status} >>',
        action: () => Navigator.pop(state.context),
      );

  }else{ //Slot in available 
        //Look up Firestore to see if any bookedBy field's 'value is under current user email address
        try{
           QuerySnapshot querySnapshot = await Firestore.instance.collection(Space.SPACECOLLECTION).
              where('bookedBy', isEqualTo: state.user.email).getDocuments();
  
        //user did not reserve or no parking lot in parkingSpace collection
        if(querySnapshot==null || querySnapshot.documents.length ==0)    
            {
              print('user has not reserved any spot');
             //-------------------------------------------------------------
            if(slotIndex.length == 0){       //Not reserve any slot yet
        //Dialog box pop up
        //Click OK to reserve, CANCEL to cancel
        //------------------------------------------------------------------------
    showDialog(
      context: state.context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Confirmation',style: TextStyle(color: Colors.blue, fontFamily: 'Modak', fontSize: 30),),
          content: Text('Would you like to reserve A$index?') ,
          actions: <Widget>[
           
            RaisedButton(
              child: Text('YES',style: TextStyle(color: Colors.blue, fontFamily: 'Modak', fontSize: 20),),
              color: Colors. yellow,
              onPressed: () async{
                slotIndex.add(index);         //Add the index of the slot to array
                for(var item in slotIndex){   //Debug
                print('reserve: A$item');  
              
                }
                
                //---------------------------------------------------------
                //Get documentID of selected available spot
                try{
                    QuerySnapshot querySnapshot = await Firestore.instance.collection(Space.SPACECOLLECTION)
                                            .where('parkingNumber', isEqualTo:'A$index')
                                            .getDocuments();
                    var spaces = <Space>[];
                    if(querySnapshot == null || querySnapshot.documents.length == 0){
                    print('no docID found');
                    return spaces;
                  }
                  for(DocumentSnapshot doc in querySnapshot.documents){

                  //spaces.add(Space.deserialize(doc.data, doc.documentID));
                  print('Selected docID: ${doc.documentID}');
                  //---------------------------------------------------------
                  //Get reservation timestamp
                 
                 var t = DateTime.now().millisecondsSinceEpoch;
                 DateTime dd = DateTime.fromMillisecondsSinceEpoch(t);
                
                 print('Time recorded: $dd');
         
                //-----------------------------
                //set state on BookNewService Page to be updated
                state.stateChanged((){
                  state.spaceList[index].status = 'reserved';
                  state.spaceList[index].lastUpdatedAt = dd;
                 
                });
                  //---------------------------------------------------------
                  //Update status in Firestore
                
                  Firestore.instance.collection('parkingSpace')
                      .document('${doc.documentID}').updateData({
                      'parkingNumber': "A$index",
                      'status'       : "reserved",
                      'bookedBy'     : "${state.user.email}",
                      'lastUpdatedAt': dd,
                      'checkInTime'  :"",
                      'checkOutTime' :"",
                      });

                //Return to BookNewService Page
                Navigator.pop(state.context);
              
                //Navigator.pop(state.context);
                //Reservation confirm dialog box
                                       
                  }
                  return spaces;
                  }catch(e){
                    throw e;
                  }
              },
            ),
             RaisedButton(
              child: Text('NO',style: TextStyle(color: Colors.blue, fontFamily: 'Modak', fontSize: 20),),
              color: Colors. yellow,
              onPressed: () => Navigator.pop(state.context),
            ),
            
          ],
        );
        
      },
    );


  }

             //-------------------------------------------------------------
            }
        else { //user already reserved a spot
              //-----------
               for (DocumentSnapshot doc in querySnapshot.documents){
                  //print('Reserved space docID: ${doc.documentID}');
                  spaces.add(Space.deserialize(doc.data, doc.documentID));
               }
              //-----------
              for(var item in spaces){
                reserveSpotNumber = item.parkingNumber;
                statusFlag = item.status;
              }

            MyDialog.info(
              context: state.context,
              title: 'Reservation Error!!!',
              message: 'Your current parking status: << $statusFlag >>\nYour parking space code: $reserveSpotNumber',
              action: (){
                Navigator.pop(state.context);
              }
            );
         }
      
        }
        catch(e){
          throw e;
        }
    }
 }
 

  void backButton() {
    print('backButton called');
    //Go to HomePage 
    Navigator.push(state.context,MaterialPageRoute(   //Move to HomePage
          builder: (context) => HomePage(state.user,state.spaceList),
        ));   //Navigate to UserHomePage
  }
}