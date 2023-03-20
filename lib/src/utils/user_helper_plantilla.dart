import 'dart:convert';

import 'package:book_river/src/api/api_client.dart';
import 'package:book_river/src/api/api_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/User.dart';

class UserHelper {
  static User? _user;
  static String? _accessToken;

  ///Nom que li posarem a la key del map que guarda l'user
  static final String sharedUserData = "user_data";

  ///getters
  static User? get user => _user;

  static String? get accessToken => _accessToken;

  ///Revisar si s'ha inciat sessió
  static bool hasUserSession() {
    if (_user != null) {
      return true;
    }
    return false;
  }

  static setUser(Map<String, dynamic> json) {
    _user = User.fromJson(json);
  }

  static setAccessToken(String token) {
    _accessToken = token;
  }

  static Future getUserDataFromSharedPreferences() async {
    try {
      // Obtenim les dades de SharedPreferences y hem de carregarles correctament
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userData = prefs.getString(sharedUserData);

      if (userData != null) {
        var _json = jsonDecode(userData);
        if (_json != null) {
          setUser(_json['user']);
          setAccessToken(_json['access_token']);
        }
      }
    } catch (e, s) {
      print("ERROR getUserDataFromSharedPreferences: $e");
      print(s);
      rethrow;
    }
  }

  /// Request registre usuari
  static Future<bool> register(Map<String, dynamic> params) async {
    try {
      dynamic _response = await ApiClient().register(params);
      if (_response != null) {
        //final prefs = await SharedPreferences.getInstance();
        await updateUserData(_response);
        return true;
      }
      return false;
    } on ApiException catch (ae) {
      ae.printDetails();
    }
    return false;
  }

  static Future<bool> login(Map<String, dynamic> params) async {
    try {
      dynamic _response = await ApiClient().signIn(params);
      if (_response != null) {
        //final prefs = await SharedPreferences.getInstance();
        await updateUserData(_response);
        return true;
      }
      return false;
    } on ApiException catch (ae) {
      ae.printDetails();
    }
    return false;
  }

  static Future<bool> recovery(Map<String, dynamic> params) async {
    try {
      dynamic _response = await ApiClient().recovery(params);
      if (_response != null) {
        //final prefs = await SharedPreferences.getInstance();
        return true;
      }
      return false;
    } on ApiException catch (ae) {
      ae.printDetails();
    }
    return false;
  }

  /// Actualitza el valor de [_user] i actualitza les dades locals de SharedPreferences
  /// de l'usuari que ha iniciat sessió.
  /// Tenir en compte que s'ha d'actualitzar el access token si existeix!
  static Future updateUserData(Map<String, dynamic> json) async {
    try {
      if (json["access_token"] != null) {
        // Actualitzem Access Token
        setAccessToken(json["access_token"]);
      } else {
        /// En cas de no tenir access_token (estem editant perfil) afegim el paràmetre
        /// per no perdre el valor al actualitzar les dades amb [setUser].
        json.putIfAbsent("access_token", () => accessToken);
      }

      // Actualitzem instància User
      setUser(json["user"]);

      // Guardem les dades a SharedPreferences
      await saveUserDataOnSharedPreferences(json);
    } catch (e, s) {
      print("ERROR updateUserData:");
      print("$e");
      print("$s");
    }
  }

  /// Actualitza el valor de les dades de l'usuari a SharedPreferences.
  static Future saveUserDataOnSharedPreferences(
      Map<String, dynamic> json) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(sharedUserData, jsonEncode(json));
  }

  ///Eliminem la info del user de ShredPreferences
  static Future _removeUserDataFromSharedPreferences() async {}
}
