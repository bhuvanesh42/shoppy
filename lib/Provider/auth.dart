import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppy/Model/https_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userid;
  DateTime _expridate;
  Timer _authtimer;

  bool get isauth {
    return token != null;
  }

  String get token {
    if (_expridate != null &&
        _expridate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userid {
    return _userid;
  }

  Future<void> authendication(
      String email, String password, String urlsegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlsegment?key=AIzaSyApdYITROkSncqNWIsmMqtyMS1x4uJloOI';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      print(json.decode(response.body));
      final responsedata = json.decode(response.body);
      if (responsedata['error'] != null) {
        throw HttpsException(responsedata['error']['message']);
      }
      _token = responsedata['idToken'];
      _userid = responsedata['localId'];
      _expridate = DateTime.now()
          .add(Duration(seconds: int.parse(responsedata['expiresIn'])));
      autologout();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userdata = json.encode({
        'token': _token,
        'userId': _userid,
        'expiryDate': _expridate.toIso8601String()
      });
      pref.setString('userData', userdata);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return authendication(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return authendication(email, password, 'signInWithPassword');
  }
  Future<bool> tryautologin () async{
    final pref = await SharedPreferences.getInstance();
    if(!pref. containsKey('userData')){
      return false;
    }
    final extracteduserdata = json.decode(pref.getString('userData')) as Map<String, Object>;
    final expirydate = DateTime.parse(extracteduserdata['expiryDate']);
    if(expirydate.isBefore(DateTime.now())){
      return false;
    }

    _token = extracteduserdata['token'];
    _userid = extracteduserdata['userId'];
    _expridate = expirydate;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _userid = null;
    _expridate = null;
    _token = null;
    if (_authtimer != null) {
      _authtimer.cancel();
      _authtimer = null;
    }
    notifyListeners();
    final perf = await SharedPreferences.getInstance();
    perf.clear();
  }

  void autologout() {
    if (_authtimer != null) {
      _authtimer.cancel();
    }
    final timetoexpiry = _expridate.difference(DateTime.now()).inSeconds;
    _authtimer = Timer(Duration(seconds: timetoexpiry), logout);
  }
}
