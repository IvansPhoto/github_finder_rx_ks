import 'package:flutter/material.dart';
import 'package:github_finder_rx_ks/widgets.dart';

class SelectedUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(title: Text('Selected users'), elevation: 0, centerTitle: true),
	    body: Center(
		    child: Text('It will be soon.', style: Theme.of(context).textTheme.display3,),
	    ),
    );
  }
}
