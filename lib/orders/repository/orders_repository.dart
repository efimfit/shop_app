import 'dart:convert';

import 'package:shop_app/orders/orders.dart';
import 'package:shop_app/cart/cart.dart';
import 'package:shop_app/products/products.dart';

class OrdersRepository {
  final FirebaseRealtimeApi firebaseRealtimeApi;
  OrdersRepository(
    this.firebaseRealtimeApi,
  );

  Future<Order> addOrder(List<Cart> cartProducts, double total,
      String authToken, String userId) async {
    try {
      final timestamp = DateTime.now();
      final body = json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((e) => {
                  'id': e.id,
                  'title': e.title,
                  'quantity': e.quantity,
                  'price': e.price,
                })
            .toList(),
      });
      final response =
          await firebaseRealtimeApi.addOrder(authToken, userId, body);
      return Order(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Order>> fetchProducts(String authToken, String userId) async {
    try {
      final response = await firebaseRealtimeApi.fetchOrders(authToken, userId);

      Map<String, dynamic>? fetchedData = json.decode(response.body);
      if (fetchedData == null) {
        return [];
      }

      final List<Order> loadedOrders = [];
      fetchedData.forEach((id, value) {
        loadedOrders.add(
          Order(
            id: id,
            amount: value['amount'],
            products: (value['products'] as List<dynamic>)
                .map((e) => Cart(
                      id: e['id'],
                      price: e['price'],
                      quantity: e['quantity'],
                      title: e['title'],
                    ))
                .toList(),
            dateTime: DateTime.parse(value['dateTime']),
          ),
        );
      });
      return loadedOrders.reversed.toList();
    } catch (e) {
      rethrow;
    }
  }
}
