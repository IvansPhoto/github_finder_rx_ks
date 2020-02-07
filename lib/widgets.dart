import 'package:flutter/material.dart';
import 'package:github_finder_rx_ks/services.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            centerTitle: true,
            title: Text('Title in the menu'),
          ),
          FlatButton.icon(
            onPressed: () => Navigator.pushReplacementNamed(context, RouteNames.index),
            icon: Icon(Icons.supervised_user_circle, size: 30),
            label: Text('Find user'),
          ),
          FlatButton.icon(
            onPressed: () => Navigator.pushReplacementNamed(context, RouteNames.selectedUsers),
            icon: Icon(Icons.star, size: 30),
            label: Text('Selected users'),
          ),
        ],
      ),
    );
  }
}

class ImageUrlIndicator extends StatelessWidget {
  final String url;
  final double height;
  final double width;

  final _widgetTypes = getIt.get<WidgetTypes>();

  ImageUrlIndicator({this.url, this.height, this.width});

  @override
  Widget build(BuildContext context) {
  if(_widgetTypes.imageType)
    return Image.network(
      url,
      height: height,
      width: width,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes : null,
          ),
        );
      },
    );
  else
    return FadeInImage(
      placeholder: AssetImage('assets/images/flutter-lockup.png'),
      image: NetworkImage(url),
      fadeInDuration: Duration(milliseconds: 1),
      fadeOutDuration: Duration(milliseconds: 1),
    );
  }
}