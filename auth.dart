import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String _loginStatus = '';

  Future<String> _makeRequest() async {
    var url = Uri.parse('https://rostov.vam-balkon.com/page_a/db.txt');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body); // выводим тело ответа в консоль
      var data = response.body;

      var users = LineSplitter().convert(data);
      for (var user in users) {
        var userDetails = user.split(':');
        if (userDetails[0] == usernameController.text &&
            userDetails[1] == passwordController.text) {
          bool isConnected = await checkInternetConnection();
          if (isConnected) {
            Navigator.pushNamed(context, '/screen1');
          } else {
            setState(() {
              _loginStatus = 'No internet connection';
            });
          }
          return 'Успешная авторизация';
        }
      }
      return 'Ошибка авторизации! Обратитесь в поддержку ';
    } else {
      return 'Нет соединения с сервером';
    }
  }


  void _login() async {
    setState(() {
      _loginStatus = 'Logging in...';
    });
    String result = await _makeRequest();
    setState(() {
      _loginStatus = result;
    });
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/auth.png',
                        height: 300,
                        width: 300,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Авторизация',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: 350,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                controller: usernameController,
                                decoration: InputDecoration(
                                    hintText: 'Ваше имя'),
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                    hintText: 'Ваш пароль'),
                                obscureText: true,
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                            SizedBox(height: 6),
                            ElevatedButton(
                              onPressed: _login,
                              child: Text('Авторизироваться'),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding:
                                EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 24),
                              ),
                            ),
                            SizedBox(height: 6),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      if (_loginStatus.isNotEmpty)
                        Dismissible(
                          key: Key('error'),
                          direction: DismissDirection.down,
                          onDismissed: (direction) {
                            setState(() {
                              _loginStatus = '';
                            });
                          },
                          child: Container(
                            width: 400,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Center(
                                child: Text(
                                  _loginStatus,
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Служба поддержки example@gmail.com',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
