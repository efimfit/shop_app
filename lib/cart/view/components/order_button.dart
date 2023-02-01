import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shop_app/cart/cart.dart';
import 'package:shop_app/orders/orders.dart';

class OrderButton extends StatefulWidget {
  const OrderButton({super.key});

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartBloc>();
    return TextButton(
      onPressed: (cart.state.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Future(() => context.read<OrdersBloc>().add(OrderAdded(
                  cart.state.cartItems.values.toList(),
                  cart.state.totalAmount)));
              setState(() {
                _isLoading = false;
              });
              await Future(
                  () => context.read<CartBloc>().add(const ClearSubmitted()));
            },
      style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary),
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text('ORDER NOW'),
    );
  }
}
