// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'orders_bloc.dart';

enum OrdersStatus { initial, loading, success, failed }

class OrdersState {
  const OrdersState({
    this.items = const [],
    this.token = '',
    this.userId = '',
    this.status = OrdersStatus.initial,
  });

  final List<Order> items;
  final String token;
  final String userId;
  final OrdersStatus status;

  OrdersState copyWith({
    List<Order>? items,
    String? token,
    String? userId,
    OrdersStatus? status,
  }) {
    return OrdersState(
      items: items ?? this.items,
      token: token ?? this.token,
      userId: userId ?? this.userId,
      status: status ?? this.status,
    );
  }
}
