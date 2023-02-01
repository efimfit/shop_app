import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop_app/auth/auth.dart';
import 'package:shop_app/app/app.dart';

class AuthRepository {
  final FirebaseAuthApi firebaseAuthApi;

  AuthRepository(this.firebaseAuthApi);

  Future<Map<String, Object>> autheticate(
      String email, String password, String segmentUrl) async {
    try {
      final body = json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      });
      final response = await firebaseAuthApi.getToken(body, segmentUrl);
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }
      final expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      final userData = json.encode({
        'token': responseData['idToken'],
        'userId': responseData['localId'],
        'expiryDate': expiryDate.toIso8601String(),
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', userData);

      final Map<String, Object> authData = {
        'token': responseData['idToken'],
        'userId': responseData['localId'],
        'expiryDate': expiryDate,
      };
      return authData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return {};

    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return {};
    return extractedData;
  }

  Future<void> clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
