import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String image;
  DetailScreen({this.image});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              image,
            ),
            
          ),
        ),
        
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
