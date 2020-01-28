
import 'dart:async';
import 'package:bookreview/controller/myfirebase.dart';
import 'package:bookreview/model/parking_space.dart';
import 'package:bookreview/view/booknewservice.dart';
import 'package:bookreview/view/mappage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPageController{
  MapPageState state;
  MapPageController(this.state);
  GoogleMapController maoController;
  Completer<GoogleMapController>_controller = Completer();
  void _onMapCreated(GoogleMapController controler){
    _controller.complete(controler);
  }
  List<String>documentList = []; 
  List<Space> spaces = [];

Future showParkingLots() async {
  if(state.documentList!=null){
        print(state.documentList);
        documentList.clear();
      }
    //------
     QuerySnapshot querySnapshot = await Firestore.instance.collection('parkingSpace')
        .getDocuments();
          if(querySnapshot==null || querySnapshot.documents.length == 0){
            print('no docID found');
          }
            for(DocumentSnapshot doc in querySnapshot.documents){
            spaces.add(Space.deserialize(doc.data, doc.documentID));
    }
  
    //------



      parkingLots().whenComplete(updateState);
  }
 Future<Null> parkingLots() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection('parkingSpace')
        .getDocuments();
          if(querySnapshot==null || querySnapshot.documents.length == 0){
            print('no docID found');
          }
            for(DocumentSnapshot doc in querySnapshot.documents){
          documentList.add(doc.documentID); 
          //spaceList.add(Space.deserialize(doc.data, doc.documentID));
    }
   // for(var item in spaceList){
   //     print('${item.parkingNumber}: ${item.status}');
   // }
    
    state.stateChanged((){});

}
  Future updateState() async {
  if(state.documentList!=null){
    state.documentList.clear();
  }
  state.documentList = <String>[]..addAll(documentList) ;
  //print('Space length: ${spaces.length}');
  //--------
   print('Space length: ${spaces.length}');
   for(var item in spaces){
     print('${item.parkingNumber}: ${item.status}');
   }  
  //--------
  //update state for spaceList in UI
  //state.stateChanged((){
    for (var item in spaces){
      state.spaceList = <Space>[]..addAll(spaces) ;
    }
  //});
  for (var i in state.spaceList){
      if (i.lati != null){
      state.markers.add(Marker(
      markerId: MarkerId(i.parkingNumber),
      position: LatLng(double.parse(i.lati), double.parse(i.longti)),
      infoWindow: InfoWindow(title: '${i.parkingNumber} <${i.status}>'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueRed,
      ),
        
        onTap: (){
        print('${i.parkingNumber} tapped');
   

      },
      //Custom Button
     
    ));}
    }
  }
  
  List<Space> spaceList;
  Future reserve() async {
    print('reserve() called');
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
}


  
