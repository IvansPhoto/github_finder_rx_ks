import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:github_finder_rx_ks/widgets.dart';
import 'package:github_finder_rx_ks/services.dart';

class SearchingUsersPage extends StatefulWidget {
  @override
  _SearchingUsersPageState createState() => _SearchingUsersPageState();
}

class _SearchingUsersPageState extends State<SearchingUsersPage> {
  final _formKey = GlobalKey<FormState>();
  final _streamService = getIt.get<StreamService>();
  final _searchParams = getIt.get<SearchParameters>();

  TextEditingController _userNameKey;
  TextEditingController _perPageKey;
  String _widgetType;

  @override
  void initState() {
    _widgetType = 'Scaffold';
    _userNameKey = TextEditingController();
    _perPageKey = TextEditingController(text: _searchParams.resultPerPage.toString());
    super.initState();
  }

  @override
  void dispose() {
    _userNameKey.dispose();
    _perPageKey.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build Scaffold SearchingUsersPage');
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Index Page'),
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) => PopupMenuButton(
                captureInheritedThemes: true,
                elevation: 0,
                onSelected: (result) {
                  _widgetType = result;
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Result will be shown on $_widgetType'),
                      elevation: 0,
                      duration: Duration(milliseconds: 1000),
                    ),
                  );
                },
                itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(child: Text('Scaffold'), value: 'Scaffold'),
                      const PopupMenuItem(child: Text('Slivers'), value: 'Slivers'),
                    ]),
          )
        ],
      ),
      body: Center(
        child: Form(
            key: _formKey,
            autovalidate: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 25),
                  Text('Search a user by his login and profile properties.'),
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _userNameKey,
                    maxLength: 25,
                    decoration: const InputDecoration(hintText: 'Input a user name'),
                    validator: (value) => value.isEmpty ? 'Enter a user name here.' : null,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _perPageKey,
                    maxLength: 3,
                    decoration: const InputDecoration(hintText: 'Show matches per one page'),
                    inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                    validator: (data) {
                      if (data.isEmpty)
                        return 'Set matches per page.';
                      else if (RegExp(r'[\D]').hasMatch(data))
                        return 'It should be a number!';
                      else if ((int.tryParse(data, radix: 10) > 100) || (int.tryParse(data, radix: 10) <= 0))
                        return 'The number shoud be from 1 to 100!';
                      else
                        return null;
                    },
                  ),
                  SizedBox(height: 10),
                  RaisedButton.icon(
                      elevation: 0,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _searchParams.searchString = _userNameKey.text; //Set search string to object.
                          _searchParams.resultPerPage = int.parse(_perPageKey.text);
                          _searchParams.pageNumber = 1;
                          ApiRequests.searchUsers(context: context, streamService: _streamService, searchParams: _searchParams);
                          switch (_widgetType) {
                            case 'Scaffold':
                              Navigator.pushNamed(context, RouteNames.users);
                              break;
                            case 'Slivers':
                              Navigator.pushNamed(context, RouteNames.usersSliver);
                              break;
                          }
                        } else {
                          return null;
                        }
                      },
                      icon: Icon(Icons.search),
                      label: Text('Start searching')),
                ],
              ),
            )),
      ),
    );
  }
}
