import 'package:bookreview/controller/myfirebase.dart';
import 'package:bookreview/model/book.dart';
import 'package:bookreview/model/parking_space.dart';
import 'package:bookreview/view/booknewservice.dart';
import 'package:bookreview/view/bookpage.dart';
import 'package:bookreview/view/frontpage.dart';
import 'package:bookreview/view/homepage.dart';
import 'package:bookreview/view/mappage.dart';
import 'package:bookreview/view/mycheckoutdialog.dart';
import 'package:bookreview/view/myconfirmdialog.dart';
import 'package:bookreview/view/mydialog.dart';
import 'package:bookreview/view/profilepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePageController{
  HomePageState state;
  HomePageController(this.state);
  List<Space>spaceList;
  bool reserveFlag;   //a flag to know if the user not/have reserved a spot
  String reserveSpotNumber = 'No Reservation';  //to store value of reserved spot
  String statusFlag;  //to store current status of reserved spot
  List<int> slotIndex = [];  //carry all the slots in parkingSpace collection

  void signOut(){
    MyFirebase.signOut();

     //Display confirmation dialog box after user clicking on "Sign Out" button
    showDialog (
      context: state.context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Confirmation',style: TextStyle(color: Colors.blue, fontFamily: 'Modak', fontSize: 30),),
          content: Text('Would you like to sign out?') ,
          actions: <Widget>[
            RaisedButton(
              child: Text('YES', style: TextStyle(color: Colors.blue, fontFamily: 'Modak', fontSize: 20),),
              color: Colors. yellow,
              onPressed: (){
                //Dialog box pop up to confirm signing out
                MyFirebase.signOut();       
                //Close Drawer, then go back to Front Page
                Navigator.pop(state.context);  //Close Dialog box
                Navigator.pop(state.context);  //Close Drawer
                //Navigator.pop(state.context);  //Close Home Page 
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> FrontPage(),
                ));
              },
            ),
            RaisedButton(
              child: Text('NO', style: TextStyle(color: Colors.blue, fontFamily: 'Modak', fontSize: 20),),
              color: Colors. yellow,
              onPressed: ()=>Navigator.pop(state.context),  //close dialog box 
            ),
          ],
        );
        
      },
    );
  }

  void addButton() async{
    //When clicked, navigate to bookPage
    Book b = await Navigator.push(state.context,MaterialPageRoute(
      builder: (context) => BookPage(state.user,null),   //send user info, if dont pass book, add new book     
    ));
    if(b != null) {
      //Store new book in firebase
      state.booklist.add(b);
    } else{
      //error occur in storing in firebase
    }
  }

  void onTap(int index) async {
    // NAVIGATE TO BOOK PAGE
    if(state.deleteIndices == null){

    //Move to BookDetail Page
   Book b = await Navigator.push(
     state.context, 
     MaterialPageRoute(
    builder: (context) => BookPage(state.user, state.booklist[index]),
    ));

    if(b != null){
      //update book is stored in Firebase
      state.booklist[index] = b;
      }
    } else{
        //ADD TO DELETE 
        if(state.deleteIndices.contains(index)){   //Tap again
            state.deleteIndices.remove(index);
            if(state.deleteIndices.length == 0){
              //all deselected -> delete mode quit
              state.deleteIndices = null;
            }
        } else {
          state.deleteIndices.add(index);
        }
        state.stateChanged((){});
      } 
  }

  void longPress(int index){
    if (state.deleteIndices == null){
      
      state.stateChanged((){
        //begin delete mode
      state.deleteIndices = <int>[index];

      });
    }
  }

  void deleteButton() async {
    //sort decending order of deleteIndices to avoice shifting of index when delete
    state.deleteIndices.sort((n1,n2){
      if(n1 < n2) return 1;

      else if (n1 == n2) return 0;
      else  return -1;
    });


    //deleteIndices list: [a,b,c]
    //Delete book from screen and from Firestore 
    for(var index in state.deleteIndices){
      try{
        await MyFirebase.deleteBook(state.booklist[index]);
      //delete from booklist
      state.booklist.removeAt(index);
      }catch(e){
        print('BOOK DELETE ERROR: ' + e.toString());   //Error meesage
      }
    }
    //change state on screen
    state.stateChanged((){
      state.deleteIndices = null;
    });
  }

  void mapButton(){
    print('findButton clicked');

    Navigator.push(state.context, MaterialPageRoute(
      builder: (context) => MapPage(state.user,state.spaceList),  
    ));
  }

  void profileButton(){
    print('profileButton clicked');
    Navigator.push(state.context, MaterialPageRoute(
      builder: (context) =>ProfilePage(state.user),  
    ));
  }

 
  void bookService() async{
    print('BookNewService clicked');  //for debug

   try{
      spaceList = await MyFirebase.getParkingSpace();
    }catch(e){
     spaceList = <Space>[];
    }
    
      print('Total # of spaces: ' + spaceList.length.toString());
      
      for(var space in spaceList){
      print('${space.parkingNumber}  ${space.status}');   
    }

    //Navgator to Book A New Service/Reservation Page
    Navigator.push(state.context, MaterialPageRoute(
      builder: (context) => BookNewService(state.user,this.spaceList),
    ));
  }
  //global array
  var spaces = <Space>[];

  void currentStatus() async{
    print('resevationStatus button cliked');
    spaces.clear();  //avoid accumulated array 
    try{
      //Find document ID in collection parkingSpace where bookedBy field is == user email
      QuerySnapshot querySnapshot = await Firestore.instance.collection(Space.SPACECOLLECTION).
        where('bookedBy', isEqualTo: state.user.email).getDocuments();
  
        //user did not reserve or no parking lot in parkingSpace collection
        if(querySnapshot==null || querySnapshot.documents.length ==0)    
          {
            //------
        MyDialog.popProgressBar(state.context);
        
        MyDialog.info(
        context: state.context,
        title: 'Current status',
        message:
        'You have no reservation',
        action: (){
          Navigator.pop(state.context);
        },     
      );   
            //------            
            reserveFlag = false;          
 }
        else{
          reserveFlag = true;
          for (DocumentSnapshot doc in querySnapshot.documents){            
          print('Reserved space docID: ${doc.documentID}');
            
          spaces.add(Space.deserialize(doc.data, doc.documentID));
          MyConfirmDialog.popProgressBar(state.context);
    
    //Dialog box 
      for(var space in spaces){
        print(space.parkingNumber);
        print(space.status);
        reserveSpotNumber = space.parkingNumber;
        statusFlag =space.status;
      }  
   if(statusFlag == 'reserved'){
    MyConfirmDialog.info(
        context: state.context,
        title: 'Current status',
        message:
        'Your reserved parking space code: $reserveSpotNumber',
        cancelReseervation: () async {
         print ('cancelReservation clicked');
         //Update Firebase
         //---------------
        QuerySnapshot querySnapshot = await Firestore.instance.collection(Space.SPACECOLLECTION).
            where('bookedBy', isEqualTo: state.user.email).getDocuments();
            var t = DateTime.now().millisecondsSinceEpoch;
                 DateTime dd = DateTime.fromMillisecondsSinceEpoch(t);
                
                 print('Time recorded: $dd');
                  Firestore.instance.collection('parkingSpace')
                      .document('${doc.documentID}').updateData({
                      'checkInTime': "",
                      'status': "Available",
                      'lastUpdatedAt': dd,
                      'bookedBy': "",
                      });
          //Exit dialog box
          Navigator.pop(state.context);
          //Dislay OK dialog for cancel complete
          MyDialog.info(
            context: state.context,
            title:'Cancelled',
            message: 'Your status has been updated',
            action: (){ 
            Navigator.pop(state.context);}  //Dispose dialog box 
          );
         //---------------
        },
       
        checkIn: () async {
          print('checkIn clicked');
        // CLICK CHECK IN, CHANGE STATUS OF REVELAVANT SPOT TO CHECK IN 
        //Retrieve again document ID of the spot where current user reserve
        //AT THIS POINT, NO NEED TRY CATCH SINCE THE USER FORE SURE HAS A RESERVATION SPOT
        QuerySnapshot querySnapshot = await Firestore.instance.collection(Space.SPACECOLLECTION).
        where('bookedBy', isEqualTo: state.user.email).getDocuments();
         var t = DateTime.now().millisecondsSinceEpoch;
                 DateTime dd = DateTime.fromMillisecondsSinceEpoch(t);
                
                 print('Time recorded: $dd');
                  Firestore.instance.collection('parkingSpace')
                      .document('${doc.documentID}').updateData({
                      'checkInTime': dd,
                      'status': "Checked In",
                      'lastUpdatedAt': dd,
                      
                      });
        //---
        //Navigator.pop(state.context);  //Exit dialog box after click check in button
         //Exit dialog box
          Navigator.pop(state.context);
          //Dislay OK dialog for cancel complete
          MyDialog.info(
            context: state.context,
            title:'Checked In',
            message: 'Your status has been updated',
            action: (){ 
            Navigator.pop(state.context);}  //Dispose dialog box 
          );
        },
       
      ); } else{
         MyCheckOutDialog.info(
        context: state.context,
        title: 'Current status',
        message:
        'Current status: $statusFlag\nCurrent Parking Space code: $reserveSpotNumber',
        checkOut: () async {
          print('checkOut button clicked');
          //CHECK OUT
          //UPDATE STATUS TO AVAILABLE IN RELEVANT PARKING NUMBER
          //------------------
           QuerySnapshot querySnapshot = await Firestore.instance.collection(Space.SPACECOLLECTION).
           where('bookedBy', isEqualTo: state.user.email).getDocuments();
            var t = DateTime.now().millisecondsSinceEpoch;
                 DateTime dd = DateTime.fromMillisecondsSinceEpoch(t);
                
                 print('Time recorded: $dd');
                Firestore.instance.collection('parkingSpace')
                      .document('${doc.documentID}').updateData({
                      'status': "Available",
                      'bookedBy': "",
                      'checkOutTime': dd, 
                      'lastUpdatedAt': dd,
                      });
          //-----------------
          //Once checked out, exit dialog
          //Navigator.pop(state.context);
          //Exit dialog box
          Navigator.pop(state.context);
          //Dislay OK dialog for cancel complete
          MyDialog.info(
            context: state.context,
            title:'Checked Out',
            message: 'Your status has been updated',
            action: (){ 
            Navigator.pop(state.context);}  //Dispose dialog box 
          );
         //---------------


        },
        ok: (){
          Navigator.pop(state.context);
        },     
      );   
      }       
     }      
   }   
}
    catch(e) {
      throw e;
      }
  }

  void viewMap() {
    print('viewMap() called');
    //Navigate to google Map
    //Show CS Parking Lot on google map based on lati and longti
      Navigator.push(state.context, MaterialPageRoute(
      builder: (context) => MapPage(state.user,state.spaceList), 
      )
    );
  }
}
