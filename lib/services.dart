import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'package:get_it/get_it.dart';
import 'package:github_finder_rx_ks/apiClasses.dart';

abstract class RouteNames {
  static const String index = '/';
  static const String menu = '/menu';
  static const String users = '/users';
  static const String profile = '/profile';
  static const String loading = '/loading';
  static const String error = '/error';
  static const String setPage = '/setpage';
  static const String selectedUsers = '/selectedUsers';
}

GetIt getIt = GetIt.instance;

class SearchParameters {
  String searchString;
  int pageNumber;
  int resultPerPage;

  SearchParameters({this.searchString, this.pageNumber = 1, this.resultPerPage = 5});

  void increasePage() => pageNumber++;

  void decreasePage() => pageNumber--;
}

class StreamService {
  final _searchParameters = BehaviorSubject.seeded(SearchParameters(pageNumber: 1, resultPerPage: 5));
  Stream get streamSearch$ => _searchParameters.stream;
  SearchParameters get currentSearch => _searchParameters.value;
  set setSearch(currentSearch) => _searchParameters.add(currentSearch);

  final _gitHubUserResponse = BehaviorSubject<GitHubUserResponse>();
  Stream get streamGHUResponse$ => _gitHubUserResponse.stream;
  GitHubUserResponse get currentGHUResponse => _gitHubUserResponse.value;
  set setGHUResponse(GitHubUserResponse gitHubUserResponse) => _gitHubUserResponse.add(gitHubUserResponse);
}

class WidgetTypes {
  int usersGridInsteadList;
  bool imageType;
  WidgetTypes({this.imageType = false, this.usersGridInsteadList = 0});
}

abstract class ApiRequests {
  static void searchUsers({@required BuildContext context, @required StreamService streamService}) async {
    streamService.setGHUResponse = null; //Set to null to make 'snapshot.hasData = false' in the page of search result.
    try {
      Response response = await get(
          'https://api.github.com/search/users?q=${streamService.currentSearch.searchString}&per_page=${streamService.currentSearch.resultPerPage}&page=${streamService.currentSearch.pageNumber}');
      print(
          'https://api.github.com/search/users?q=${streamService.currentSearch.searchString}&per_page=${streamService.currentSearch.resultPerPage}&page=${streamService.currentSearch.pageNumber}');
      streamService.setGHUResponse = GitHubUserResponse.fromJson(jsonDecode(response.body), response.headers['status']);
    } catch (error) {
      Navigator.pushNamed(context, RouteNames.error, arguments: error); //Check error type.
      print('The error: ' + error);
    }
  }
}
