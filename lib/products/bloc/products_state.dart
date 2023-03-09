// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'products_bloc.dart';

enum ProductsStatus { initial, loading, success, failed }

class ProductsState {
  const ProductsState({
    this.items = const [],
    this.userItems = const [],
    this.token = '',
    this.userId = '',
    this.status = ProductsStatus.initial,
  });

  final List<Product> items;
  final List<Product> userItems;
  final String token;
  final String userId;
  final ProductsStatus status;

  List<Product> get favouriteItems {
    return items.where((e) => e.isFavourite).toList();
  }

  List<Product> toogleFavouriteProduct(String id, bool newStatus) {
    return items
        .map((e) => e.id == id ? (e..isFavourite = newStatus) : e)
        .toList();
  }

  Product findById(String id) {
    return items.firstWhere((e) => e.id == id);
  }

  ProductsState copyWith({
    List<Product>? items,
    List<Product>? userItems,
    String? token,
    String? userId,
    ProductsStatus? status,
  }) {
    return ProductsState(
      items: items ?? this.items,
      userItems: userItems ?? this.userItems,
      token: token ?? this.token,
      userId: userId ?? this.userId,
      status: status ?? this.status,
    );
  }
}
