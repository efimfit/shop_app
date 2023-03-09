import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shop_app/cart/cart.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';

  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your cart')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(15),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(fontSize: 20)),
                        const Spacer(),
                        Chip(
                          label: Text(
                            '\$${state.totalAmount.toStringAsFixed(2)}',
                            style:
                                Theme.of(context).primaryTextTheme.titleMedium,
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        const OrderButton(),
                      ]),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: state.itemCount,
                  itemBuilder: ((ctx, i) {
                    return CartItem(
                      id: state.cartItems.values.toList()[i].id,
                      title: state.cartItems.values.toList()[i].title,
                      price: state.cartItems.values.toList()[i].price,
                      quantity: state.cartItems.values.toList()[i].quantity,
                      productId: state.cartItems.keys.toList()[i],
                    );
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
