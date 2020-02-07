import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:github_finder_rx_ks/widgets.dart';
import 'package:github_finder_rx_ks/services.dart';

class SearchingUsersPage extends StatefulWidget {
  @override
  _SearchingUsersPageState createState() => _SearchingUsersPageState();
}

class _SearchingUsersPageState extends State<SearchingUsersPage> {
  final _streamService = getIt.get<StreamService>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _userNameKey;
  TextEditingController _perPageKey;

  @override
  void initState() {
    super.initState();
    _userNameKey = TextEditingController();
    _perPageKey = TextEditingController(text: _streamService.currentSearch.resultPerPage.toString());
  }

  @override
  void dispose() {
    super.dispose();
    _userNameKey.dispose();
    _perPageKey.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(title: Text('Index Page'), elevation: 0, centerTitle: true),
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
                          _streamService.currentSearch.searchString = _userNameKey.text; //Set search string to object.
                          _streamService.currentSearch.resultPerPage = int.parse(_perPageKey.text);
                          _streamService.currentSearch.pageNumber = 1;
                          ApiRequests.searchUsers(context: context, streamService: _streamService);
                          Navigator.pushNamed(context, RouteNames.users);
                        } else {
                          return null;
                        }
                      },
                      icon: Icon(Icons.search),
                      label: Text('Start searching'))
                ],
              ),
            )),
      ),
    );
  }
}
