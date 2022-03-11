import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Screens/products_overview_screen.dart';
import 'package:flutter_complete_guide/Screens/userRegister_screen.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerPasswordConfirm = TextEditingController();
  List<Map<String, Object>> _pages =[];
  int _selectedPageIndex = 0;
  //bool isLoggedIn = false;
  bool _isInit = false;

  @override
  void initState() {
    Widget t;
      () async {
     t = await logIn();
  } ();
          _pages = [
      {
        'page':  t,
        'title': 'Signing In',
      },
      {
        'page': UserRegister(),
        'title': 'Signing Up',
      },
    ];
    setState(() {
      _isInit = true;
      
    });
    
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void didChangeDependencies() async {
 
    if (!_isInit) {
      WidgetsFlutterBinding.ensureInitialized();

      final keyApplicationId = '3bhBZQDpP8jaFceAgFnuGEw3p2V9Xi8nwY0H9mFe';
      final keyClientKey = '1A2fpy3fEPRpDDy5FPW7iRh5JvXjZqI5B1IysuaN';
      final keyParseServerUrl = 'https://parseapi.back4app.com';

      await Parse().initialize(keyApplicationId, keyParseServerUrl,
          clientKey: keyClientKey, debug: true);
      
    }
    else
    {

    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
      ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        currentIndex: _selectedPageIndex,
        // type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.category),
            label: 'LogIn',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.star),
            label: 'Register',
          ),
        ],
      ),
    );
  }

  Future<Widget> logIn() async {
    var auth = Provider.of<Auth>(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: const Text('Flutter on Back4App',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 16,
            ),
            Center(
              child: const Text('User Login/Logout',
                  style: TextStyle(fontSize: 16)),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              controller: controllerUsername,
              enabled: !await auth.hasUserLogged(),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.none,
              autocorrect: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  labelText: 'Username'),
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
              controller: controllerPassword,
              enabled: !await auth.hasUserLogged(),
              obscureText: true,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.none,
              autocorrect: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  labelText: 'Password'),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 50,
              child: TextButton(
                child: const Text('Login'),
                onPressed:() async  => ! await  auth.hasUserLogged()
                    ? null
                    : () {
                        auth.doUserLogin(controllerUsername.text.trim(),
                            controllerPassword.text.trim(), context);

                      },
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 50,
              child: TextButton(
                child: const Text('Logout'),
                onPressed:
                    () async  => ! await  auth.hasUserLogged() ? null : () => auth.doUserLogout(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
