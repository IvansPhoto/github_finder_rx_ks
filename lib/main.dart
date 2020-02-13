import 'package:flutter/material.dart';
import 'package:github_finder_rx_ks/pages/ResultSearchPageSlivers.dart';
import 'package:github_finder_rx_ks/pages/SelectedUsers.dart';
import 'package:github_finder_rx_ks/supportPages/ErrorScreen.dart';
import 'package:github_finder_rx_ks/supportPages/LoadingScreen.dart';
import 'package:github_finder_rx_ks/pages/SearchingUsersPage.dart';
import 'package:github_finder_rx_ks/pages/ResultSearchPage.dart';
//import 'package:github_finder_rx_ks/pages/ResultSearchPageSlivers.dart';
import 'package:github_finder_rx_ks/pages/UserProfilePage.dart';
import 'package:github_finder_rx_ks/services.dart';
import 'package:github_finder_rx_ks/pages/ChangePageNumber.dart';

void main() {
  getIt.registerLazySingleton<StreamService>(() => StreamService());
  getIt.registerLazySingleton<WidgetTypes>(() => WidgetTypes());
  runApp(MaterialApp(
    initialRoute: RouteNames.index,
    routes: {
      RouteNames.index: (BuildContext context) => SearchingUsersPage(),
      RouteNames.users: (BuildContext context) => ResultSearchPage(),
      RouteNames.usersSliver: (BuildContext context) => ResultSearchPageSlivers(),
      RouteNames.profile: (BuildContext context) => UserProfilePageFutureBuilder(),
      RouteNames.loading: (BuildContext context) => LoadingScreen(),
      RouteNames.error: (BuildContext context) => ErrorScreen(),
      RouteNames.setPage: (BuildContext context) => ChangePageNumber(),
      RouteNames.selectedUsers: (BuildContext context) => SelectedUsers(),
    }, //TODO Set only vertical layout
    theme: ThemeData(
      iconTheme: IconThemeData(color: Colors.red[900]),
      brightness: Brightness.light,
      primaryColor: Colors.red[900],
      primarySwatch: Colors.blue,
      disabledColor: Colors.indigo[500],
      accentColor: Colors.cyan[700],
      backgroundColor: Colors.red,
      buttonTheme: ButtonThemeData(
        focusColor: Colors.indigo[200],
        highlightColor: Colors.indigoAccent,
        splashColor: Colors.red[500],
        buttonColor: Colors.red[900],
        disabledColor: Colors.grey[300],
        hoverColor: Colors.redAccent,
        textTheme: ButtonTextTheme.primary,
        colorScheme: ColorScheme(
            primary: Colors.red[900],
            primaryVariant: Colors.orange,
            secondary: Colors.orange[900],
            secondaryVariant: Colors.cyanAccent,
            surface: Colors.pinkAccent,
            background: Colors.purple[900],
            error: Colors.purpleAccent,
            onPrimary: Colors.amber[900],
            onSecondary: Colors.amber[200],
            onSurface: Colors.deepPurple[900],
            onBackground: Colors.purple,
            onError: Colors.brown[500],
            brightness: Brightness.light),
      ),
      textTheme: TextTheme(
        title: TextStyle(fontSize: 20, color: Colors.orange),
        button: TextStyle(fontSize: 20, color: Colors.orange),
        body1: TextStyle(fontSize: 20, color: Colors.grey[800]),
        display1: TextStyle(fontSize: 20, color: Colors.red),
        overline: TextStyle(fontSize: 15, color: Colors.red),
        caption: TextStyle(color: Colors.red),
      ),
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.red[900],
      disabledColor: Colors.grey[200],
      buttonColor: Colors.indigo[700],
      accentColor: Colors.deepOrangeAccent,
      buttonTheme: ButtonThemeData(
        focusColor: Colors.indigo[200],
        highlightColor: Colors.indigoAccent,
        splashColor: Colors.red[500],
        buttonColor: Colors.red[900],
        disabledColor: Colors.grey[200],
        hoverColor: Colors.redAccent,
        textTheme: ButtonTextTheme.primary,
        colorScheme: ColorScheme(
            primary: Colors.red[900],
            primaryVariant: Colors.orange,
            secondary: Colors.orange[900],
            secondaryVariant: Colors.cyanAccent,
            surface: Colors.pinkAccent,
            background: Colors.purple[900],
            error: Colors.purpleAccent,
            onPrimary: Colors.amber[900],
            onSecondary: Colors.amber[200],
            onSurface: Colors.deepPurple[900],
            onBackground: Colors.purple,
            onError: Colors.brown[500],
            brightness: Brightness.light),
      ),
      iconTheme: IconThemeData(color: Colors.red[900]),
      textTheme: TextTheme(
        title: TextStyle(fontSize: 20, color: Colors.orange),
        button: TextStyle(fontSize: 20, color: Colors.orange),
        body1: TextStyle(fontSize: 20, color: Colors.grey[50]),
        display1: TextStyle(fontSize: 20, color: Colors.red[500]),
        overline: TextStyle(fontSize: 15, color: Colors.red),
        caption: TextStyle(color: Colors.red),
      ),
    ),
    title: "The App",
  ));
}
