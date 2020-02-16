import 'package:flutter/material.dart';
import 'package:github_finder_rx_ks/services.dart';

class WidgetSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        elevation: 0,
        centerTitle: true,
      ),
      body: _OptionsRadio(),
    );
  }
}

class _OptionsRadio extends StatefulWidget {
  _OptionsRadio({Key key}) : super(key: key);
  @override
  __OptionsRadioState createState() => __OptionsRadioState();
}

class __OptionsRadioState extends State<_OptionsRadio> {
  final _widgetTypes = getIt.get<WidgetTypes>();
  int _usersGridInsteadList;
  bool _imageType;

  @override
  void initState() {
    _usersGridInsteadList = _widgetTypes.showResultGridList;
		_imageType = _widgetTypes.imageType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 15,
          ),
          Text('Select the view-type of the search result.'),
          RadioListTile(
            title: Text('Set view to List ${_usersGridInsteadList == 0 ? '(current)': ''}'),
            value: 0,
            groupValue: _widgetTypes.showResultGridList,
            onChanged: (value) => setState(() => _widgetTypes.showResultGridList = value),
          ),
          RadioListTile(
            title: Text('Set view to Grid ${_usersGridInsteadList == 1 ? '(current)': ''}'),
            value: 1,
            groupValue: _widgetTypes.showResultGridList,
            onChanged: (value) => setState(() => _widgetTypes.showResultGridList = value),
          ),
          Divider(
            height: 30,
            color: Colors.cyan,
          ),
          Text('Select the view-type of avatars.'),
          RadioListTile(
            title: Text('Image with Indicator ${_imageType == true ? '(current)': ''}'),
            value: true,
            groupValue: _widgetTypes.imageType,
            onChanged: (value) => setState(() => _widgetTypes.imageType = value),
          ),
          RadioListTile(
            title: Text('Image with fade ${_imageType == false ? '(current)': ''}'),
            value: false,
            groupValue: _widgetTypes.imageType,
            onChanged: (value) => setState(() => _widgetTypes.imageType = value),
          ),
          Center(
            child: FlatButton(onPressed: () => Navigator.pop(context), child: Text('Go back to result.')),
          )
        ],
      ),
    );
  }
}
