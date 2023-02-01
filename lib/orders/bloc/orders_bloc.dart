import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shop_app/orders/orders.dart';
import 'package:shop_app/auth/auth.dart';
import 'package:shop_app/cart/cart.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc(
      {required OrdersRepository ordersRepository, required AuthBloc authBloc})
      : _ordersRepository = ordersRepository,
        _authBloc = authBloc,
        super(const OrdersState()) {
    on<OrdersFetched>(_onOrdersFetched);
    on<TokenUpdated>(_onTokenUpdated);
    on<OrderAdded>(_onOrderAdded);
    _listenToAuthBloc();
  }

  final AuthBloc _authBloc;
  final OrdersRepository _ordersRepository;
  late StreamSubscription authSubscription;

  @override
  Future<void> close() {
    authSubscription.cancel();
    return super.close();
  }

  void _listenToAuthBloc() {
    authSubscription = _authBloc.stream.listen((state) {
      if (state.token != null) {
        add(TokenUpdated(state.token!, state.userId!));
        add(const OrdersFetched());
      }
    });
  }

  void _onTokenUpdated(TokenUpdated event, Emitter<OrdersState> emit) {
    emit(state.copyWith(token: event.token, userId: event.userId));
  }

  Future<void> _onOrdersFetched(
      OrdersFetched event, Emitter<OrdersState> emit) async {
    emit(state.copyWith(status: OrdersStatus.loading));
    List<Order> items =
        await _ordersRepository.fetchProducts(state.token, state.userId);
    emit(state.copyWith(items: items, status: OrdersStatus.success));
  }

  Future<void> _onOrderAdded(
      OrderAdded event, Emitter<OrdersState> emit) async {
    final newOrder = await _ordersRepository.addOrder(
        event.cartProducts, event.total, state.token, state.userId);
    final List<Order> newItems = state.items..insert(0, newOrder);
    emit(state.copyWith(items: newItems));
  }
}
