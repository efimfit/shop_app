import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shop_app/cart/cart.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<ItemRemoved>(_onItemRemoved);
    on<ClearSubmitted>(_onClearSubmitted);
    on<ItemAdded>(_onItemAdded);
    on<SingleEntityRemoved>(_onSingleEntityRemoved);
  }

  void _onItemRemoved(ItemRemoved event, Emitter<CartState> emit) {
    final Map<String, Cart> newCartItems = state.cartItems
      ..remove(event.productId);
    emit(state.copyWith(cartItems: newCartItems));
  }

  void _onClearSubmitted(ClearSubmitted event, Emitter<CartState> emit) {
    emit(state.copyWith(cartItems: {}));
  }

  void _onItemAdded(ItemAdded event, Emitter<CartState> emit) {
    final Map<String, Cart> newItems = state.cartItems;
    if (newItems.containsKey(event.productId)) {
      newItems.update(
          event.productId,
          (e) => Cart(
              id: e.id,
              title: e.title,
              quantity: e.quantity + 1,
              price: e.price));
    } else {
      newItems.putIfAbsent(
          event.productId,
          () => Cart(
              id: DateTime.now().toString(),
              title: event.title,
              quantity: 1,
              price: event.price));
    }
    emit(state.copyWith(cartItems: newItems));
  }

  void _onSingleEntityRemoved(
      SingleEntityRemoved event, Emitter<CartState> emit) {
    if (!state.cartItems.containsKey(event.productId)) {
      return;
    }
    final Map<String, Cart> newItems = state.cartItems;
    if (newItems[event.productId]!.quantity > 1) {
      newItems.update(
          event.productId,
          (e) => Cart(
              id: e.id,
              title: e.title,
              quantity: e.quantity - 1,
              price: e.price));
    } else {
      newItems.remove(event.productId);
    }
    emit(state.copyWith(cartItems: newItems));
  }
}
