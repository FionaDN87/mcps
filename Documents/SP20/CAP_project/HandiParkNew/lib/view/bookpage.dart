import 'package:bookreview/model/book.dart';
import 'package:bookreview/view/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../controller/bookpage_controller.dart';

class BookPage extends StatefulWidget{
  final User user;
  final Book book;

  BookPage(this.user, this.book);
  @override
  State<StatefulWidget> createState() {
    
    return BookPageState(user, book);
  }

}

class BookPageState extends State<BookPage>{
  User user;
  Book book;
  Book bookCopy;
  BookPageController controller;

  var formKey = GlobalKey<FormState>();

  BookPageState(this.user, this.book){
     controller = BookPageController(this);
     if(book == null){
          //add button
          bookCopy = Book.empty();     //Begin with blank Book form
     } else{
       bookCopy = Book.clone(book);  //copy constructor to copy all fields in a book
     }
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details'),
      ),
      body: Form(
        key:formKey,
        child: ListView(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: bookCopy.imageURL,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => Icon(Icons.error_outline,size:250),
              height: 250,
              width: 250,
            ),

            TextFormField(
              initialValue: bookCopy.imageURL,
              decoration: InputDecoration(
                labelText: 'Image Url',

              ),
              autocorrect: false,
              validator: controller.validateImageURL,
              onSaved: controller.saveImageURL,
            ),

             TextFormField(
              initialValue: bookCopy.title,
              decoration: InputDecoration(
                labelText: 'Book title',

              ),
              autocorrect: false,
              validator: controller.validateTitle,
              onSaved: controller.saveTitle,
            ),

            TextFormField(
              initialValue: bookCopy.author,
              decoration: InputDecoration(
                labelText: 'Book author',

              ),
              autocorrect: false,
              validator: controller.validateAuthor,
              onSaved: controller.saveAuthor,
            ),

             TextFormField(
              initialValue: bookCopy.pubyear.toString(),
              decoration: InputDecoration(
                labelText: 'Publication year',

              ),
              autocorrect: false,
              validator: controller.validatePubyear,
              onSaved: controller.savePubyear,
            ),


            TextFormField(
              initialValue: bookCopy.sharedWith.join(',').toString(),   //Each value is joined by comma
              decoration: InputDecoration(
                labelText: 'Shared with (comma seperated email list)',

              ),
              autocorrect: false,
              validator: controller.validateSharedWith,
              onSaved: controller.saveSharedWith,
            ),
            //Multiple lines for Review
            TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'review',
                ),
                autocorrect: false,
                initialValue: bookCopy.review,
                validator: controller.validateReview,
                onSaved: controller.saveReview,
            ),

            //Three Read only information
            Text('CreatedBy: ' + bookCopy.createdBy),
            Text('Last Updated At: ' +bookCopy.lastUpdatedAt.toString()),
            Text('Document ID: ' +bookCopy.documentID.toString()),   //Fixed bug by adding toString()

            RaisedButton(
              child: Text('Save'),
              onPressed: controller.save,
            )





          ],
        ),


      ),
    );
  }

}