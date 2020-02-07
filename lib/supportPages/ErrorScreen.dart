import 'package:flutter/material.dart';
import 'package:github_finder_rx_ks/services.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final error = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text('Something went worng'), elevation: 0, automaticallyImplyLeading: false, centerTitle: true,),
      body: Container(
        color: Colors.grey[900],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            child: Text(
              error.toString(),
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.popUntil(context, ModalRoute.withName(RouteNames.index)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

//ErrorWidget
