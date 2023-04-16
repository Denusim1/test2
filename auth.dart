import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../HomeScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _loginStatus = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  Directory someDirectory = Directory('/path/to/directory');
  // Запоминание
  final _formKey = GlobalKey<FormState>();

  Future<void> autoFillCredentials() async {
    String udid = await FlutterUdid.udid;
    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');
    DatabaseEvent snapshot = await usersRef.orderByChild('udid').equalTo(udid).once();
    DataSnapshot dataSnapshot = snapshot.snapshot;
    Map<String, dynamic>? data = dataSnapshot.value as Map<String, dynamic>?;

    if (data != null) {
      String email = data.values.first['email'];
      String password = data.values.first['password'];
      _emailController.text = email;
      _passwordController.text = password;
      _rememberMe = true;
    }
  }
  void checkCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // пользователь уже авторизован, переходим на главный экран приложения
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeScreen(dir: someDirectory),
        ),
      );
    } else {
      // пользователь не авторизован, ничего не делаем
    }
  }


  bool _rememberMe = false;
  @override
  void initState() {
    super.initState();
    _loadSavedData();
    checkCurrentUser();

  }

  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    String password = prefs.getString('password') ?? '';
    _emailController.text = email;
    _passwordController.text = password;
  }


  void _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('email') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }
  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _emailController.text);
    prefs.setString('password', _passwordController.text);
    prefs.setBool('rememberMe', _rememberMe);
  }


  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential userCredential = await _auth.signInWithCredential(credential);

    return userCredential;
  }


  Future<void> _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _loginStatus = 'Введите имя пользователя и пароль';
      });
      return;
    }
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String token = userCredential.user!.uid;
      String udid = await FlutterUdid.udid;

      bool isTokenValid = await _checkToken(token, udid );
      print(token);

      if (isTokenValid) {
        Navigator.push(
          context,
           MaterialPageRoute(builder: (context) => HomeScreen(dir: someDirectory)),
        );
      } else {
        setState(() {
          _loginStatus = 'Неверный логин или пароль';
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _loginStatus = 'Неверный логин или пароль';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          _loginStatus = 'Неверный логин или пароль';
        });
      } else {
        setState(() {
          _loginStatus = 'Ошибка при входе: $e';
        });
      }
    }
  }

  Future<bool> _checkToken(String token, udid ) async {
    DatabaseEvent event = await _database.ref().child('users').child(token).once();
    DataSnapshot snapshot = event.snapshot;
    print(snapshot.value);
    if (snapshot.value == null) {
      print('Данные не найдены в базе данных');
      return false;
    } else {
      Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
      if (data != null && data['udid'] == udid ) {
        return true;
      } else {
        print('Устройство не авторизовано');
        return false;
      }
    }
  }
  Future<void> _register() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _loginStatus = 'Введите имя пользователя и пароль';
      });
      return;
    }
    String udid = await FlutterUdid.udid;

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String token = userCredential.user!.uid;
      FirebaseDatabase.instance.ref().child('users').child(token).set({
        'email': email,
        'token': token,
        'udid': udid,
        // здесь вы можете добавить дополнительные данные пользователя
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(dir: someDirectory)),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast('Слабый пароль');
        setState(() {
          _loginStatus = 'Слабый пароль';
        });
      } else if (e.code == 'email-already-in-use') {
        showToast('Пользователь уже существует');
        setState(() {
          _loginStatus = 'Пользователь уже существует';
        });
      } else {
        showToast('Ошибка при регистрации: $e');
        setState(() {
          _loginStatus = 'Ошибка при регистрации: $e';
        });
      }
    }
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




  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 4, // время задержки в секундах
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 12.0);
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
                            const SizedBox(height: 5),
                            const Text(
                              'Авторизация',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
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
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: TextField(
                                      controller: _emailController,
                                      decoration:
                                      const InputDecoration(hintText: 'Ваша почта'),
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: TextField(
                                      controller: _passwordController,
                                      decoration:
                                      const InputDecoration(hintText: 'Ваш пароль'),
                                      obscureText: true,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (value) {
                                        // Implement your logic when user submits the password
                                      },
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  ElevatedButton(
                                    onPressed: () async {
                                      bool isConnected = await checkInternetConnection();
                                      if (!isConnected) {
                                        setState(() {
                                          showToast('Отсутствует подключение к интернету');
                                          _loginStatus = 'Отсутствует подключение к интернету';
                                        });
                                        return;
                                      }
                                      await _login();
                                    },
                                    child: const Text('Авторизация'),
                                    style: ButtonStyle(
                                      fixedSize: MaterialStateProperty.all(Size(200, 42)), // задаем размеры кнопки
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25.0), // указываем радиус скругления углов
                                      )),
                                    ),
                                  ),
                                  const SizedBox(height: 5),

                                  ElevatedButton(
                                    onPressed: () async {
                                      bool isConnected = await checkInternetConnection();
                                      if (!isConnected) {
                                        setState(() {
                                          showToast('Отсутствует подключение к интернету');
                                          _loginStatus = 'Отсутствует подключение к интернету';
                                        });
                                        return;
                                      }
                                      try {
                                        UserCredential userCredential =
                                        await _auth.createUserWithEmailAndPassword(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        );
                                        String token = userCredential.user!.uid;
                                        String udid = await FlutterUdid.udid;
                                        FirebaseDatabase.instance.ref().child('users').child(token).update({
                                          'email': _emailController.text,
                                          'token': token,
                                          'udid': udid,
                                          // здесь вы можете добавить дополнительные данные пользователя
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => HomeScreen(dir: someDirectory)),
                                        );
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'weak-password') {
                                              showToast('Пароль должен состаять минимум из шести символов');
                                              setState(() {
                                                _loginStatus = 'Слабый пароль';
                                              });
                                        } else if (e.code == 'email-already-in-use') {
                                          showToast('Этот пользователь уже зарегистрирован');
                                          setState(() {
                                            _loginStatus = 'Пользователь уже существует';
                                          });
                                        } else if (e.code == 'invalid-email') {
                                          showToast('Неправильный формат почты');
                                          setState(() {
                                            _loginStatus = 'Неправильный формат почты';
                                          });
                                        } else {
                                          showToast('Ошибка при регистрации. Укажите почту и пароль минимум из 6 символов');
                                          setState(() {
                                            _loginStatus = 'Ошибка при регистрации: $e';
                                          });
                                        }
                                      } catch (e) {
                                        showToast('Ошибка при регистрации. Укажите почту и пароль минимум из 6 символов');
                                        setState(() {
                                          _loginStatus = 'Ошибка при регистрации: $e';
                                        });
                                      }
                                    },
                                    child: const Text('Регистрация'),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                                      fixedSize: MaterialStateProperty.all(Size(200, 42)), // задаем размеры кнопки
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25.0), // указываем радиус скругления углов
                                      )),
                                        ),
                                      ),
                                  const SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                        ]
                      ),
                    ),
                  ),
              ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Служба поддержки example@gmail.com',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
          ),
      ),
    );
  }
}
