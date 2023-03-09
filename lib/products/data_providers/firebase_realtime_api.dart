import 'package:http/http.dart' as http;

class FirebaseRealtimeApi {
  Future<http.Response> toogleFavourite(
      String authToken, String userId, String id, String body) async {
    final url = Uri.parse(
        'https://mini-shop-75236-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$authToken');
    final response = http.put(url, body: body);
    return response;
  }

  Future<http.Response> addOrder(
      String authToken, String userId, String body) async {
    final url = Uri.parse(
        'https://mini-shop-75236-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final response = await http.post(url, body: body);
    return response;
  }

  Future<http.Response> fetchOrders(String authToken, String userId) async {
    final url = Uri.parse(
        'https://mini-shop-75236-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    return response;
  }

  Future<http.Response> fetchProducts(String authToken, String filter) async {
    final url = Uri.parse(
        'https://mini-shop-75236-default-rtdb.firebaseio.com/products.json?auth=$authToken$filter');
    final response = await http.get(url);
    return response;
  }

  Future<http.Response> fetchFavouriteProducts(
      String authToken, String userId) async {
    final url = Uri.parse(
        'https://mini-shop-75236-default-rtdb.firebaseio.com/userFavourites/$userId.json?auth=$authToken');
    final response = await http.get(url);
    return response;
  }

  Future<http.Response> addProduct(String authToken, String body) async {
    final url = Uri.parse(
        'https://mini-shop-75236-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    final response = await http.post(url, body: body);
    return response;
  }

  Future<void> updateProduct(String authToken, String id, String body) async {
    final url = Uri.parse(
        'https://mini-shop-75236-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    await http.patch(url, body: body);
  }

  Future<http.Response> deleteProduct(String authToken, String id) async {
    final url = Uri.parse(
        'https://mini-shop-75236-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');

    final response = await http.delete(url);
    return response;
  }
}
