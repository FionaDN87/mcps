
import 'package:bookreview/view/frontpage.dart';
import 'package:flutter/material.dart';


void main() { 
  
  runApp(BookReviewApp());}

class BookReviewApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home:FrontPage(),
    );
  }

}

