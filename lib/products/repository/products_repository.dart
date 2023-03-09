import 'dart:convert';

import 'package:shop_app/products/products.dart';

class ProductsRepository {
  final FirebaseRealtimeApi firebaseRealtimeApi;

  ProductsRepository(this.firebaseRealtimeApi);

  Future<void> toogleFavourite(
      String token, String userId, bool newStatus, String id) async {
    try {
      final body = json.encode(
        newStatus,
      );
      final response =
          await firebaseRealtimeApi.toogleFavourite(token, userId, id, body);
      if (response.statusCode >= 400) {
        throw Error();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteProduct(String authToken, String id) async {
    try {
      final response = await firebaseRealtimeApi.deleteProduct(authToken, id);
      return response.statusCode >= 400 ? false : true;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Product>> fetchProducts(String authToken, String userId,
      {required bool filterByUser}) async {
    try {
      final filter =
          filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';

      final List<Product> loadedProducts = [];
      var response = await firebaseRealtimeApi.fetchProducts(authToken, filter);
      Map<String, dynamic>? fetchedData = json.decode(response.body);
      if (fetchedData == null) {
        return [];
      }

      response =
          await firebaseRealtimeApi.fetchFavouriteProducts(authToken, userId);
      Map<String, dynamic>? favouriteData = json.decode(response.body);

      fetchedData.forEach((id, prodData) {
        loadedProducts.add(Product(
          id: id,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavourite:
              favouriteData == null ? false : favouriteData[id] ?? false,
        ));
      });
      return loadedProducts;
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> addProduct(
      Product newProduct, String authToken, String userId) async {
    try {
      final body = json.encode({
        'title': newProduct.title,
        'price': newProduct.price,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'creatorId': userId,
      });
      final response = await firebaseRealtimeApi.addProduct(authToken, body);
      final product = Product(
          id: json.decode(response.body)['name'],
          title: newProduct.title,
          description: newProduct.description,
          price: newProduct.price,
          imageUrl: newProduct.imageUrl);
      return product;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProduct(Product newProduct, String authToken) async {
    try {
      final body = json.encode({
        'title': newProduct.title,
        'price': newProduct.price,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
      });
      await firebaseRealtimeApi.updateProduct(authToken, newProduct.id, body);
    } catch (e) {
      rethrow;
    }
  }
}
