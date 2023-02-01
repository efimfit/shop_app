import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shop_app/cart/cart.dart';
import 'package:shop_app/products/products.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: BlocSelector<ProductsBloc, ProductsState, bool>(
            selector: (state) => state.findById(product.id).isFavourite,
            builder: (context, state) {
              return IconButton(
                icon: Icon(state ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  context
                      .read<ProductsBloc>()
                      .add(FavouriteToogled(state, product.id));
                },
                color: Colors.deepOrange,
              );
            },
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              context
                  .read<CartBloc>()
                  .add(ItemAdded(product.id, product.title, product.price));
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                  'Added to chart!',
                  textAlign: TextAlign.left,
                ),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () => context
                        .read<CartBloc>()
                        .add(SingleEntityRemoved(product.id))),
              ));
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
          backgroundColor: Colors.black54,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetails.routeName, arguments: product);
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
