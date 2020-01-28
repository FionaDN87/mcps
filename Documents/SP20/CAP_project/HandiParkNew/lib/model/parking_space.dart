class Space{
  String documentID;   //firestore doc ID
  String status;
  String parkingNumber;
  String bookedBy;
  DateTime lastUpdatedAt;   //created or revised time
  DateTime checkInAt; 
  DateTime checkOutAt;
  String lati;
  String longti;
  //Constructor
  Space({
    this.status,
    this.parkingNumber,
    this.bookedBy,
    this.lastUpdatedAt,
    this.checkInAt,
    this.checkOutAt,
    this.lati,
    this.longti,
   
  });

  //Empty book 
  //Name book constructor
  Space.empty(){
    this.status = '';

    this.bookedBy = '';
    //this.parkingNumber =   automatically updated
    //this.lastUpdatedAt,   automatically updated
  
  }

  //Copy/clone constructor
  Space.clone(Space b){
    this.documentID = b.documentID;
    this.status = b.status;
    this.parkingNumber = b.parkingNumber;
    this.lastUpdatedAt = b.lastUpdatedAt;
    this.bookedBy = b.bookedBy;
   

  }

  Map<String, dynamic> serialize(){
    return <String, dynamic> {
      PARKINGNUMBER: parkingNumber,
      STATUS: status,
      LASTUPDATEDAT: lastUpdatedAt,
      BOOKEDBY: bookedBy,
      CHECKINAT: checkInAt,
      CHECKOUTAT: checkOutAt,
    };
  }

  static Space deserialize(Map<String,dynamic> data, String docID){
    print('deserialize');
    var space = Space(
     status: data [Space.STATUS],
     bookedBy: data[Space.BOOKEDBY],
     parkingNumber: data[Space.PARKINGNUMBER],
     checkInAt: data[Space.CHECKINAT],
     checkOutAt: data[Space.CHECKOUTAT],
     lati: data[Space.LATI],
     longti: data[Space.LONGTI],
    );
    if(data[Space.LASTUPDATEDAT] != null){
      space.lastUpdatedAt = DateTime.fromMillisecondsSinceEpoch(
        data[Space.LASTUPDATEDAT].millisecondsSinceEpoch);   
    }
    space.documentID = docID;
    return space;
  }



  //Constance for Firestore
  static const SPACECOLLECTION = 'parkingSpace';
  //Field names in Firestore
  static const STATUS = 'status';
  static const PARKINGNUMBER = 'parkingNumber';
  static const BOOKEDBY = 'bookedBy';
  static const LASTUPDATEDAT = 'lastUpdatedAt';
  static const CHECKINAT = 'checkInAt';
  static const CHECKOUTAT = 'checkOutAt';
  static const LATI = 'lati';
  static const LONGTI  = 'longti';
}
//-------------------------------------------------------


