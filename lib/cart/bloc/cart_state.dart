// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cart_bloc.dart';

class CartState {
  const CartState({
    this.cartItems = const {},
  });

  final Map<String, Cart> cartItems;

  int get itemCount {
    return cartItems.length;
  }

  double get totalAmount {
    var total = 0.0;
    cartItems.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  CartState copyWith({
    Map<String, Cart>? cartItems,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
    );
  }
}
