import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_finder_rx_ks/pages/WidgetSettingsPage.dart';
import 'package:github_finder_rx_ks/pages/ChangePageNumber.dart';
import 'package:github_finder_rx_ks/services.dart';
import 'package:github_finder_rx_ks/widgets.dart';
import 'package:github_finder_rx_ks/apiClasses.dart';

class ResultSearchPageSlivers extends StatelessWidget {
  final _streamService = getIt.get<StreamService>();
  final _widgetTypes = getIt.get<WidgetTypes>();

  @override
  Widget build(BuildContext context) {
    print('build Scaffold ResultSearchPageSlivers');
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('The Users have found!'),
            elevation: 0,
            floating: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WidgetSettingPage(), fullscreenDialog: true)),
              )
            ],
          ),
          _SearchingButton(),
          StreamBuilder(
              stream: _streamService.streamGHUResponse$,
              // ignore: missing_return
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData)
                  return _LoadingScreenSliver();
                else if (_streamService.currentGHUResponse.headerStatus != '200 OK')
                  return _ApiError(_streamService.currentGHUResponse);
                else
                  switch (_widgetTypes.showResultGridList) {
                    case 0:
                      return _SliverListUserView(snapshot.data.users);
                    case 1:
                      return _SliverGridUsersView(snapshot.data.users);
                  }
              }),
          _SearchingButton(),
        ],
      ),
    );
  }
}

class _LoadingScreenSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Container(
          child: Text('Loading', style: Theme.of(context).textTheme.display2),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          color: Colors.grey[900],
        ),
      ]),
    );
  }
}

class _SliverGridUsersView extends StatelessWidget {
  final List<GitHubUsers> gitHubUsers;
  _SliverGridUsersView(this.gitHubUsers);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => GridTile(
          footer: Container(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Center(child: Text(gitHubUsers[index].login, style: Theme.of(context).textTheme.display1)),
          ),
          child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () => Navigator.pushNamed(context, RouteNames.profile,
                  arguments: {'url': gitHubUsers[index].url, 'avatarUrl': gitHubUsers[index].avatarUrl, 'login': gitHubUsers[index].login}),
              child: Hero(
                tag: gitHubUsers[index].avatarUrl,
                child: ImageUrl(url: gitHubUsers[index].avatarUrl),
              )),
        ),
        childCount: gitHubUsers.length,
      ),
    );
  }
}

class _SliverListUserView extends StatelessWidget {
  final List<GitHubUsers> gitHubUsers;
  _SliverListUserView(this.gitHubUsers);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => Card(
          elevation: 0,
          margin: EdgeInsets.symmetric(horizontal: 1, vertical: 3),
          child: Row(
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                child: Hero(
                  tag: gitHubUsers[index].avatarUrl,
                  child: ImageUrl(url: gitHubUsers[index].avatarUrl),
                ),
              ),
              Container(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Login: ' + gitHubUsers[index].login),
                  Text('Score: ' + gitHubUsers[index].score.toString()),
                  RaisedButton(
                    elevation: 0,
                    onPressed: () => Navigator.pushNamed(context, RouteNames.profile,
                        arguments: {'url': gitHubUsers[index].url, 'avatarUrl': gitHubUsers[index].avatarUrl, 'login': gitHubUsers[index].login}),
                    child: Text('View profile'),
                  ),
                ],
              ),
            ],
          ),
        ),
        childCount: gitHubUsers.length,
      ),
    );
  }
}

class _SearchingButton extends StatelessWidget {
  final _streamService = getIt.get<StreamService>();
  final _searchParams = getIt.get<SearchParameters>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _streamService.streamGHUResponse$,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return SliverToBoxAdapter(
              child: Container(),
            );
          } else {
            final _pageNumber = _searchParams.pageNumber;
            final _resultPerPage = _searchParams.resultPerPage;
            final _totalCount = _streamService.currentGHUResponse.totalCount;
            final int _theLastPageNumber = (_totalCount / _resultPerPage).ceil();
            final int _apiMaxPage = (1000 ~/ _resultPerPage).ceil();
            return SliverList(
              delegate: SliverChildListDelegate.fixed([
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    FlatButton(
                      child: Icon(Icons.navigate_before, size: 35),
                      onPressed: _pageNumber != 1
                          ? () {
                              _searchParams.decreasePage();
                              ApiRequests.searchUsers(streamService: _streamService, context: context, searchParams: _searchParams);
                            }
                          : null,
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChangePageNumber(), fullscreenDialog: true));
                      },
                      child: Column(
                        children: <Widget>[
                          Text('Tap to change page', style: Theme.of(context).textTheme.overline),
                          Text('$_pageNumber / ${_theLastPageNumber > _apiMaxPage ? _apiMaxPage : _theLastPageNumber}', style: Theme.of(context).textTheme.overline),
                        ],
                      ),
                    ),
                    FlatButton(
                      child: Icon(Icons.navigate_next, size: 35),
                      onPressed: ((_totalCount / _resultPerPage) != _pageNumber && _pageNumber < (1000 / _resultPerPage))
                          ? () {
                              _searchParams.increasePage();
                              ApiRequests.searchUsers(streamService: _streamService, context: context, searchParams: _searchParams);
                            }
                          : null,
                    ),
                  ],
                ),
              ]),
            );
          }
        });
  }
}

class _ApiError extends StatelessWidget {
  final GitHubUserResponse currentGHUResponse;
  _ApiError(this.currentGHUResponse);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(currentGHUResponse.headerStatus),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(currentGHUResponse.message, style: Theme.of(context).textTheme.overline),
              ),
              Text(currentGHUResponse.docUrl),
            ],
          ),
        )
      ]),
    );
  }
}
