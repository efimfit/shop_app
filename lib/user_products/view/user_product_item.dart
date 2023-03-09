import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shop_app/user_products/user_products.dart';
import 'package:shop_app/products/products.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem(
      {super.key,
      required this.id,
      required this.title,
      required this.imageUrl});

  final String id;
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProduct.routeName, arguments: id);
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () async {
                try {
                  context.read<ProductsBloc>().add(ProductDeleted(id));
                } catch (e) {
                  scaffold.hideCurrentSnackBar();
                  scaffold.showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Deleting failed!',
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
