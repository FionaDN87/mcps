import 'package:firebase_auth/firebase_auth.dart';

class User{
  String profilePic;
  String email;
  String password;
  String displayName;
  int zip;

  String uid; //uid in Firestore 



  //Creative 
  FirebaseAuth auth;
  FirebaseUser user;


  //User constructor
  User({
    this.email,
    this.password,
    this.displayName,
    this.zip,
    this.uid,
    this.profilePic,
    
  });

  Map<String, dynamic> serialize(){
      return <String,dynamic>{
        EMAIL: email,
        DISPLAYNAME: displayName,
        ZIP: zip,
        UID: uid,
        PROFILE_PIC: profilePic,
      };
  }

  static User deserialize (Map<String,dynamic> document){
    return User(
      email: document[EMAIL],
      displayName: document [DISPLAYNAME],
      zip: document [ZIP],
      uid: document [UID],
      profilePic:  document [PROFILE_PIC],
    );
  }

  //password is saved in authentication
  static const PROFILE_COLLECTION = 'userprofile';
  static const EMAIL = 'email';
  static const DISPLAYNAME = 'displayName';
  static const ZIP = 'zip';
  static const UID = 'uid';
  static const PROFILE_PIC = 'profilePic';
}