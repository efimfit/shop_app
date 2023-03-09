part of 'orders_bloc.dart';

abstract class OrdersEvent {
  const OrdersEvent();
}

class OrdersFetched extends OrdersEvent {
  const OrdersFetched();
}

class TokenUpdated extends OrdersEvent {
  const TokenUpdated(this.token, this.userId);

  final String token;
  final String userId;
}

class OrderAdded extends OrdersEvent {
  const OrderAdded(this.cartProducts, this.total);

  final List<Cart> cartProducts;
  final double total;
}
