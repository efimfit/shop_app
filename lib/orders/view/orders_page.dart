import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shop_app/app/app.dart';
import 'package:shop_app/orders/orders.dart';

class OrdersPage extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your orders')),
      drawer: const AppDrawer(),
      body: BlocBuilder<OrdersBloc, OrdersState>(builder: (context, state) {
        if (state.status == OrdersStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (state.status == OrdersStatus.failed) {
            return const Center(
              child: Text('Error occurred'),
            );
          } else {
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: ((cxt, i) => OrderItem(order: state.items[i])),
            );
          }
        }
      }),
    );
  }
}
