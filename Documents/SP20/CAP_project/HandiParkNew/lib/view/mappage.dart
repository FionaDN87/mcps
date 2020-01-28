

import 'dart:async';
import 'package:bookreview/controller/mappage_controller.dart';
import 'package:bookreview/model/parking_space.dart';
import 'package:bookreview/view/user.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget{
  User user;
  final List<Space> spaceList;
  MapPage(this.user, this.spaceList);
  @override
  State<StatefulWidget> createState() {
    return MapPageState(user,spaceList);
  }

}

class MapPageState extends State<MapPage>{
  User user;
  List<Marker> markers;
  List<String> documentList = [];
  List<Space> spaceList;
  List<Space> spaces;
  Completer<GoogleMapController> _controller = Completer();
  MapPageController controller;
   MapPageState(this.user, this.spaceList) {
    controller = MapPageController(this);

      Marker csParkingArea = Marker(
      markerId: MarkerId('CS Parking area'),
      position: LatLng(35.654217, -97.474146),
      infoWindow: InfoWindow(title: 'CS Parking Area'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueAzure,
      ),
    );
 
     markers=<Marker>[]..add(csParkingArea);
     
   }
   void stateChanged(Function fn) {
    setState((){
    });
   
  }
  static final CameraPosition csParkingLot = CameraPosition(
    target: LatLng(35.654217, -97.474146),
    zoom: 18.3,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('CS parking lots', style: TextStyle(fontSize: 40,fontFamily: 'Modak', color: Colors.white)),
        backgroundColor: Colors.blue,
       
      ),
      body: 
      GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: csParkingLot,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        compassEnabled: true,

        markers: Set.from(markers),
             
      ),
  /*    
      floatingActionButton: 
      Padding(
        padding: const EdgeInsets.only(top:650,left:70),
        child: FloatingActionButton.extended(
          onPressed: controller.showParkingLots,
          label: Text('Lots', style: TextStyle(fontSize: 20, fontFamily: 'Modak', color: Colors.blue)),
          icon: Icon(Icons.local_parking, color: Colors.blue,),
          backgroundColor: Colors.yellow,
        ),
      )
  */    
  floatingActionButton: Stack(
    children: <Widget>[
       Padding(
        padding: const EdgeInsets.only(top:600,right:125),
        child: RaisedButton(
        child: Text('Reserve',style: TextStyle(fontSize: 20, fontFamily: 'Modak', color: Colors.blue)),
        onPressed: controller.reserve,
        color: Colors.yellow,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18),
          side: BorderSide(color:Colors.blue),
        ),     
        ),
      ),
      Padding(
       padding: const EdgeInsets.only(top:645,right:125),
       child: RaisedButton(
        child: Text('Lots        ',style: TextStyle(fontSize: 20, fontFamily: 'Modak', color: Colors.blue)),
        onPressed: controller.showParkingLots,
        color: Colors.yellow,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18),
          side: BorderSide(color:Colors.blue),)
        //label: Text('Lots', style: TextStyle(fontSize: 20, fontFamily: 'Modak', color: Colors.blue)),
        //icon: Icon(Icons.local_parking, color: Colors.blue,),
        //backgroundColor: Colors.yellow,
       ),
      ),
    ],
  ),

    
    );
   
  }
/*
  Marker csParkingArea = Marker(
      markerId: MarkerId('CS Parking area'),
      position: LatLng(35.654217, -97.474146),
      infoWindow: InfoWindow(title: 'CS Parking Area'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueAzure,
      ),
    );
*/
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

}






