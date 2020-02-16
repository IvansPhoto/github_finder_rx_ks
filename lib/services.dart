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
  static const String usersSliver = '/usersSliver';
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

  SearchParameters({this.searchString, this.pageNumber, this.resultPerPage});

  void increasePage() => pageNumber++;
  void decreasePage() => pageNumber--;
}

class WidgetTypes {
  int showResultGridList; //Grid - 0, List - 1.
  bool imageType; //Fade - false,Indicator -  true.
  int crossAxisCount;

  WidgetTypes({this.imageType, this.showResultGridList, this.crossAxisCount});
}

enum userWidgetType {List, Grid}

class StreamService {
  final _gitHubUserResponse = BehaviorSubject<GitHubUserResponse>();
  Stream get streamGHUResponse$ => _gitHubUserResponse.stream;
  GitHubUserResponse get currentGHUResponse => _gitHubUserResponse.value;
  set setGHUResponse(GitHubUserResponse gitHubUserResponse) => _gitHubUserResponse.add(gitHubUserResponse);
}

abstract class ApiRequests {
  static void searchUsers({@required BuildContext context, @required StreamService streamService, @required SearchParameters searchParams}) async {
    streamService.setGHUResponse = null; //Set to null to make 'snapshot.hasData = false' in the page of search result.
    try {
      Response response = await get(
          'https://api.github.com/search/users?q=${searchParams.searchString}&per_page=${searchParams.resultPerPage}&page=${searchParams.pageNumber}');
      print(
          'https://api.github.com/search/users?q=${searchParams.searchString}&per_page=${searchParams.resultPerPage}&page=${searchParams.pageNumber}');
      streamService.setGHUResponse = GitHubUserResponse.fromJson(jsonDecode(response.body), response.headers['status']);
    } catch (error) {
      Navigator.pushNamed(context, RouteNames.error, arguments: error); //Check error type.
      print('The error: ' + error);
    }
  }
}
