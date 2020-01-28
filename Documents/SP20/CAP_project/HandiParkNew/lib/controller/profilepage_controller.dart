import 'package:bookreview/view/profilepage.dart';

class ProfilePageController{
  ProfilePageState state;

  ProfilePageController(this.state);

  String validateDisplayName(value){
    if(value == null || value.length <3){
     return 'Enter at least 3 characters';
   }
   return value;
    
  }

  void saveDislayName(String value){
    state.stateChanged((){
        state.user.displayName = value;
    });
  }

  void updateButton() async {
    
    print('updateButton clicked');

    print(state.user.displayName);


    //Update profile info on screen and in Firestore 





  }

}

