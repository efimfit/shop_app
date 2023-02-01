// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cart_bloc.dart';

abstract class CartEvent {
  const CartEvent();
}

class ItemAdded extends CartEvent {
  const ItemAdded(
    this.productId,
    this.title,
    this.price,
  );

  final String productId;
  final String title;
  final double price;
}

class ClearSubmitted extends CartEvent {
  const ClearSubmitted();
}

class ItemRemoved extends CartEvent {
  const ItemRemoved(this.productId);

  final String productId;
}

class SingleEntityRemoved extends CartEvent {
  const SingleEntityRemoved(this.productId);

  final String productId;
}
