import 'package:http/http.dart' as http;

class FirebaseAuthApi {
  static const webApiKey = 'AIzaSyBf4eYJzgtsTWmmKYWrUuXmFttPY9v41bE';

  Future<http.Response> getToken(String body, String segmentUrl) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$segmentUrl?key=$webApiKey');

    final response = await http.post(url, body: body);
    return response;
  }
}
