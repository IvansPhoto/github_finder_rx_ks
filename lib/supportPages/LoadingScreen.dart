import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return SafeArea(
			child: Container(
				color: Colors.red[900],
				child: Center(
					child: SpinKitCubeGrid(color: Colors.grey[50], size: 250),
				),
			),
		);
	}
}
