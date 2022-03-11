import 'dart:convert';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  bool _isLoggedIn;

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        Uri.parse('https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyC13spCwP_f_SalxEbkB-wjedoF8iYENlQ');
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    print(json.decode(response.body));
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }

    Future<bool> hasUserLogged() async {
    ParseUser currentUser = await ParseUser.currentUser() as ParseUser;
    if (currentUser == null) {
      return false;
    }
    //Checks whether the user's session token is valid
    final ParseResponse parseResponse =
        await ParseUser.getCurrentUserFromServer(currentUser.sessionToken);

    if (parseResponse?.success == null || !parseResponse.success) {
      //Invalid session. Logout
      await currentUser.logout();
      return false;
    } else {
      return true;
    }
  }

    void doUserLogin(String uName, String pass , BuildContext context) async {
    final username = uName;
    final password = pass;

    final user = ParseUser(username, password, null);

    var response = await user.login();

    if (response.success) {
      showSuccess("User was successfully login!",context);
        _isLoggedIn = true;
        //Navigator.of(context).pushNamed(ProductsOverviewScreen.routeName);
    } else {
      showError(response.error.message,context);
    }
    print(_isLoggedIn.toString());
  }

  void doUserLogout(BuildContext context) async {
    final user = await ParseUser.currentUser() as ParseUser;
    var response = await user.logout();

    if (response.success) {
      showSuccess("User was successfully logout!",context);
        _isLoggedIn = false;
    } else {
      showError(response.error.message ,context);
    }
  }

  
  void showSuccess(String message , BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: Text(message),
          actions: <Widget>[
            new TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showError(String errorMessage, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            new TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
