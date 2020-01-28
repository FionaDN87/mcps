import 'package:bookreview/model/book.dart';
import 'package:bookreview/model/parking_space.dart';
import 'package:bookreview/view/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyFirebase {

  //Create account
  static Future<String> createAccount({String email, String password,String profilePic}) async {
    AuthResult auth = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
      
    );
    return auth.user.uid;
  }

  static void createProfile(User user) async {
    await Firestore.instance.collection(User.PROFILE_COLLECTION)
          .document(user.uid)
          .setData(user.serialize());
  }


  //Check if the username is on database after user clicked LOG IN button
  static Future<String> login({String email, String password}) async {    //Define named variables of email/password
    AuthResult auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,

    );
    return auth.user.uid;      //Read user/password, if username/password is in FireStore, return uid
  }

  static Future<User>readProfile (String uid) async{
    DocumentSnapshot doc =  await Firestore.instance.collection(User.PROFILE_COLLECTION)
        .document(uid).get();

   return User.deserialize(doc.data);
  }

  static void signOut(){
    FirebaseAuth.instance.signOut();
  }

   //Creative
 static Future<void> resetPass(String email) async{
   await FirebaseAuth.instance.sendPasswordResetEmail(email:email);
 }
    
    //Add book to firebase 
  static Future<String> addBook (Book book) async{
    DocumentReference ref = await Firestore.instance.collection(Book.BOOKSCOLLECTION)
          .add(book.serialize());

    return ref.documentID;
  }
 
static Future<List<Book>> getBooks(String email) async{

    QuerySnapshot querySnapshot = await Firestore.instance.collection(Book.BOOKSCOLLECTION)
      .where(Book.CREATEDBY, isEqualTo: email)
      .getDocuments();
    var booklist = <Book>[];
    if (querySnapshot == null || querySnapshot.documents.length ==0){
      print('Empty booklist');
      return booklist;
    }
    for (DocumentSnapshot doc in querySnapshot.documents){
      print('Something in booklist');
      booklist.add(Book.deserialize(doc.data, doc.documentID));

    }
    return booklist;

  }


   static Future<void> updateBook (Book book) async {
     await Firestore.instance.collection(Book.BOOKSCOLLECTION)
        .document(book.documentID)
        .setData(book.serialize());
   }
/*
   static Future<void> updateSlot (Space space) async {
     await Firestore.instance.collection(Space.SPACECOLLECTION)
        .document(Space.documentID)
        .setData(Space.serialize());
   }
*/

   static Future<void> deleteBook(Book book)async {
     await Firestore.instance.collection(Book.BOOKSCOLLECTION)
        .document(book.documentID).delete();

   }

   static Future<List<Book>> getBooksSharedWithMe(String email) async{
     try{
       QuerySnapshot querySnapshot = await Firestore.instance.collection(Book.BOOKSCOLLECTION)
                                            .where(Book.SHAREDWITH, arrayContains: email)
                                            .orderBy(Book.CREATEDBY)
                                            .orderBy(Book.LASTUPDATEDAT)
                                            .getDocuments();
        var books = <Book>[];
        if(querySnapshot == null || querySnapshot.documents.length == 0){
          return books;
        }
        for(DocumentSnapshot doc in querySnapshot.documents){
          books.add(Book.deserialize(doc.data, doc.documentID));
        }
        return books;
     }catch(e){
       throw e;

     }
   }


 static Future<void> updateSpace (Space space) async {
     await Firestore.instance.collection(Space.SPACECOLLECTION)
        .document(space.documentID)
        .setData(space.serialize());
   }


static Future<List<Space>> getParkingSpace() async{

    QuerySnapshot querySnapshot = await Firestore.instance.collection('parkingSpace')
      .getDocuments();
    var spaceList = <Space>[];
    if (querySnapshot == null || querySnapshot.documents.length ==0){
      print('Empty spaceList');
      return spaceList;
    }
    for (DocumentSnapshot doc in querySnapshot.documents){
      print('Something in spaceList');
      spaceList.add(Space.deserialize(doc.data, doc.documentID));
    }
    return spaceList;

  }

    
}
