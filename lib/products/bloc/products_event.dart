part of 'products_bloc.dart';

abstract class ProductsEvent {
  const ProductsEvent();
}

class ProductsFetched extends ProductsEvent {
  const ProductsFetched();
}

class FavouriteToogled extends ProductsEvent {
  const FavouriteToogled(this.isFavourite, this.id);

  final bool isFavourite;
  final String id;
}

class TokenUpdated extends ProductsEvent {
  const TokenUpdated(this.token, this.userId);

  final String token;
  final String userId;
}

class ProductDeleted extends ProductsEvent {
  const ProductDeleted(
    this.id,
  );

  final String id;
}

class ProductUpdated extends ProductsEvent {
  const ProductUpdated(
    this.product,
  );

  final Product product;
}

class ProductAdded extends ProductsEvent {
  const ProductAdded(
    this.product,
  );

  final Product product;
}
