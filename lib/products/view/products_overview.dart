import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shop_app/app/app.dart';
import 'package:shop_app/cart/cart.dart';
import 'package:shop_app/products/products.dart';

enum FilterOptions { favourites, all }

class ProductsOverview extends StatefulWidget {
  const ProductsOverview({super.key});

  @override
  State<ProductsOverview> createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  var _showFavouritesOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
            itemBuilder: ((context) {
              return [
                const PopupMenuItem(
                  value: FilterOptions.favourites,
                  child: Text('Only favourites'),
                ),
                const PopupMenuItem(
                  value: FilterOptions.all,
                  child: Text('Show all'),
                ),
              ];
            }),
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              setState(() {
                _showFavouritesOnly =
                    value == FilterOptions.favourites ? true : false;
              });
            },
          ),
          BlocSelector<CartBloc, CartState, int>(
            selector: (state) => state.itemCount,
            builder: (context, state) {
              return Badge(
                value: state.toString(),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartPage.routeName);
                  },
                ),
              );
            },
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          return state.status == ProductsStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : ProductsGrid(
                  products:
                      _showFavouritesOnly ? state.favouriteItems : state.items,
                );
        },
      ),
    );
  }
}
