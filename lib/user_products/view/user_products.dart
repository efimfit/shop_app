import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shop_app/app/app.dart';
import 'package:shop_app/products/products.dart';
import 'package:shop_app/user_products/user_products.dart';

class UserProducts extends StatelessWidget {
  static const routeName = '/user-products';

  const UserProducts({super.key});

  Future<void> _refreshProducts(BuildContext context) async {
    context.read<ProductsBloc>().add(const ProductsFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProduct.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          return state.status == ProductsStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => _refreshProducts(context),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: state.userItems.length,
                      itemBuilder: ((cxt, i) => Column(
                            children: [
                              UserProductItem(
                                id: state.userItems[i].id,
                                title: state.userItems[i].title,
                                imageUrl: state.userItems[i].imageUrl,
                              ),
                              const Divider(),
                            ],
                          )),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
