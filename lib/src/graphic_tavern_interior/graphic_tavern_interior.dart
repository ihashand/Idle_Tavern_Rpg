import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GraphicTavernInteriorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Welcome to TAVERN_NAME'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              GoRouter.of(context).go('/');
            },
          ),
        ],
      ),
      body: ListView(
        // Using ListView for the scrollable background
        scrollDirection:
            Axis.horizontal, // Allowing scrolling in the horizontal direction
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width *
                2, // Set the container width to span two pages
            child: Image.asset(
              'assets/images/menu/tavern-interior.png', // Your image path
              fit: BoxFit.cover, // Adjust the fit as needed
            ),
          ),
        ],
      ),
    );
  }
}
