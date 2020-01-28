class Book{
  String documentID;   //firestire doc ID
  String title;
  String author;
  int pubyear;
  String imageURL;
  String review;
  String createdBy;
  DateTime lastUpdatedAt;   //created or revised time
  //Array
  List<dynamic> sharedWith;    //Share list of books

  //Constructor
  Book({
    this.title,
    this.author,
    this.pubyear,
    this.imageURL,
    this.review,
    this.createdBy,
    this.lastUpdatedAt,
    this.sharedWith,
  });

  //Empty book 
  //Name book constructor
  Book.empty(){
    this.title = '';
    this.author = '';
    this.pubyear = 2000;
    this.imageURL = '';
    this.review = '';
    this.createdBy = '';
    //this.lastUpdatedAt,   automatically updated
    this.sharedWith = <dynamic>[];
  }

  //Copy/clon constructor
  Book.clone(Book b){
    this.documentID = b.documentID;
    this.title = b.title;
    this.author = b.author;
    this.pubyear = b.pubyear;
    this.review = b.review;
    this.imageURL = b.imageURL;
    this.lastUpdatedAt = b.lastUpdatedAt;
    this.createdBy = b.createdBy;
    this.sharedWith = <dynamic> []..addAll(b.sharedWith);    //deep copy since shareWith is array

  }

  Map<String, dynamic> serialize(){
    return <String, dynamic> {
      TITLE: title,
      AUTHOR: author,
      PUBYEAR: pubyear,
      IMAGEURL: imageURL,
      REVIEW : review,
      CREATEDBY: createdBy,
      LASTUPDATEDAT: lastUpdatedAt,
      SHAREDWITH: sharedWith,
    };
  }

  static Book deserialize(Map<String,dynamic> data, String docID){
    var book = Book(
      title: data [Book.TITLE],
      author: data[Book.AUTHOR],
      pubyear: data[Book.PUBYEAR],
      imageURL: data[Book.IMAGEURL],
      review: data[Book.REVIEW],
      createdBy: data[Book.CREATEDBY],
      sharedWith: data[Book.SHAREDWITH],
    );
    if(data[Book.LASTUPDATEDAT] != null){
      book.lastUpdatedAt = DateTime.fromMillisecondsSinceEpoch(
        data[Book.LASTUPDATEDAT].millisecondsSinceEpoch);   
    }
    book.documentID = docID;
    return book;
  }



  //Constance for Firestore
  static const BOOKSCOLLECTION = 'books';
  //Field names in Firestore
  static const TITLE = 'title';
  static const IMAGEURL = 'imageURL';
  static const AUTHOR = 'author';
  static const PUBYEAR = 'pubyear';
  static const REVIEW = 'review';
  static const CREATEDBY = 'createdBy';
  static const LASTUPDATEDAT = 'lastUpdatedAt';
  static const SHAREDWITH = 'sharedWith';
}
//-------------------------------------------------------


