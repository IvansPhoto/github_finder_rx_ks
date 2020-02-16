import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:github_finder_rx_ks/services.dart';

class ChangePageNumber extends StatefulWidget {
  @override
  _ChangePageNumberState createState() => _ChangePageNumberState();
}

class _ChangePageNumberState extends State<ChangePageNumber> {
  final _formKey = GlobalKey<FormState>();
  final _streamService = getIt.get<StreamService>();
  final _searchParams = getIt.get<SearchParameters>();

  TextEditingController _pageNumberKey;
  int _pageNumber;
  int _totalCount;
  int _resultPerPage;
  int _theLastPageNumber;
  int _apiMaxPage;
  int _currentPge;

  @override
  void initState() {
    super.initState();
    _pageNumberKey = TextEditingController(text: _searchParams.pageNumber.toString());
    _pageNumber = _searchParams.pageNumber;
    _totalCount = _streamService.currentGHUResponse.totalCount;
    _resultPerPage = _searchParams.resultPerPage;
    _theLastPageNumber = (_totalCount / _resultPerPage).ceil();
    _apiMaxPage = (1000 ~/ _resultPerPage).ceil();
    _currentPge = _pageNumber;
  }

  @override
  void dispose() {
    _pageNumberKey.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build Scaffold ChangePageNumber');
    return Scaffold(
      appBar: AppBar(title: Text('Select the page number.'), elevation: 0, centerTitle: true),
      body: Center(
        child: Form(
            key: _formKey,
            autovalidate: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(height: MediaQuery.of(context).size.height / 6),
                  Text('You have ${_totalCount.toString()} matches.'),
                  _totalCount > 1000
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          child: Text('The available only the first 1000 matches.', style: Theme.of(context).textTheme.overline),
                        )
                      : Container(),
                  Text('Current page - $_currentPge; the last - ${_theLastPageNumber > _apiMaxPage ? _apiMaxPage : _theLastPageNumber}.'),
                  TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    controller: _pageNumberKey,
                    textAlign: TextAlign.center,
                    maxLength: 3,
                    inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(hintText: 'Input the page number.'),
                    validator: (data) {
                      if (data.isEmpty)
                        return 'Set the Page Number.';
                      else if (int.tryParse(data, radix: 10) > (_theLastPageNumber > _apiMaxPage ? _apiMaxPage : _theLastPageNumber) || (int.tryParse(data, radix: 10) <= 0))
                        return 'The number shoud be from 1 to ${_theLastPageNumber > _apiMaxPage ? _apiMaxPage : _theLastPageNumber}';
                      else
                        return null;
                    },
                  ),
                  RaisedButton.icon(
                      elevation: 0,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _searchParams.pageNumber = int.tryParse(_pageNumberKey.text);
                          ApiRequests.searchUsers(context: context, streamService: _streamService, searchParams: _searchParams);
                          Navigator.pop(context);
                        }
                        return null;
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
