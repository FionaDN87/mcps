import 'package:bookreview/controller/myfirebase.dart';
import 'package:bookreview/view/mydialog.dart';
import 'package:flutter/cupertino.dart';

import '../view/bookpage.dart';

class BookPageController{
  BookPageState state;
  BookPageController (this.state);

  String validateImageURL(String value){
    if(value == null || value.length <5){
    return 'Enter Image URL beginning with http';
  }
  return null;
}

void saveImageURL(String value){
  state.bookCopy.imageURL = value;

}

String validateTitle(String value){
    if(value == null || value.length <5){
    return 'Enter book title';
  }
  return null;
}

void saveTitle(String value){
  state.bookCopy.title = value;

}


String validateAuthor(String value){
    if(value == null || value.length <3){
    return 'Enter book author';
  }
  return null;
}

void saveAuthor(String value){
  state.bookCopy.author = value;

}


String validatePubyear(String value){
    if(value == null){
    return 'Enter publication year';
  }
  //Check if interger or not
  try{
    int.parse(value);
  }catch(e){
    return 'Enter publication year in numbers';
  }
  return null;
}

void savePubyear(String value){
  state.bookCopy.pubyear = int.parse(value);

}

String validateSharedWith(String value){
  if(value == null || value.trim().isEmpty){
    return null;   //no sharing
  }
  for (var email in value.split(',')){   //for each value seperated by email
    if(!(email.contains('.') && email.contains('@'))){
      return 'Enter comma (,) seperated email list';
    }
    //if we have multiple @ in one field
    if(email.indexOf('@') != email.lastIndexOf('@')){
      return 'Enter comma (,) seperated email list';
    }
  }
  return null;
}

void saveSharedWith(String value){
  if(value == null || value.trim().isEmpty){
    return;
   }
   state.bookCopy.sharedWith = [];
   List<String> emaillist = value.split(',');
   for(var email in emaillist){
     state.bookCopy.sharedWith.add(email.trim());
   }
 }

 void save() async {
   if(!state.formKey.currentState.validate()){
     return;
    }
    state.formKey.currentState.save();
    print('********share with: ' + state.bookCopy.sharedWith.toString());
    
    state.bookCopy.createdBy = state.user.email;
    state.bookCopy.lastUpdatedAt = DateTime.now();
    try{
    if(state.book == null){
      //Add button
       state.bookCopy.documentID = await MyFirebase.addBook(state.bookCopy);
    } else{
      //from homepage to edit a book
      await MyFirebase.updateBook(state.bookCopy);
    }
   
    Navigator.pop(state.context, state.bookCopy);
    }catch(e){
      MyDialog.info(
        context: state.context,
        title: 'Firestore Save Error',
        message: 'Firestore is unavailable now. Try again later',
        action: (){
          Navigator.pop(state.context);   //Exit of Dialog ox
          Navigator.pop(state.context, null); //To HomePage 
        }
      );

    }
  }


  String validateReview(String value){
    if(value == null || value.length < 5){
      return 'Enter book review (min 5 chars)';
    }
    return null;
  }

  void saveReview(String value){
    state.bookCopy.review = value;
  } 

}