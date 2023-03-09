import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shop_app/products/products.dart';
import 'package:shop_app/app/app.dart';
import 'package:shop_app/auth/auth.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc({
    required ProductsRepository productsRepository,
    required AuthBloc authBloc,
  })  : _productsRepository = productsRepository,
        _authBloc = authBloc,
        super(const ProductsState()) {
    on<ProductsFetched>(_onProductsFetched);
    on<TokenUpdated>(_onTokenUpdated);
    on<FavouriteToogled>(_onFavouriteToogled);
    on<ProductDeleted>(_onProductDeleted);
    on<ProductUpdated>(_onProductUpdated);
    on<ProductAdded>(_onProductAdded);
    _listenToAuthBloc();
  }

  @override
  Future<void> close() {
    authSubscription.cancel();
    return super.close();
  }

  final ProductsRepository _productsRepository;
  final AuthBloc _authBloc;
  late StreamSubscription authSubscription;

  void _listenToAuthBloc() {
    authSubscription = _authBloc.stream.listen((state) {
      if (state.token != null) {
        add(TokenUpdated(state.token!, state.userId!));
        add(const ProductsFetched());
      }
    });
  }

  Future<void> _onProductsFetched(
      ProductsFetched event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(status: ProductsStatus.loading));

    final newItems = await _productsRepository
        .fetchProducts(state.token, state.userId, filterByUser: false);
    final newUserItems = await _productsRepository
        .fetchProducts(state.token, state.userId, filterByUser: true);

    emit(state.copyWith(
        items: newItems,
        userItems: newUserItems,
        status: ProductsStatus.success));
  }

  void _onTokenUpdated(TokenUpdated event, Emitter<ProductsState> emit) {
    emit(state.copyWith(token: event.token, userId: event.userId));
  }

  Future<void> _onFavouriteToogled(
      FavouriteToogled event, Emitter<ProductsState> emit) async {
    try {
      final newStatus = !event.isFavourite;

      emit(state.copyWith(status: ProductsStatus.loading));
      final newItems = state.toogleFavouriteProduct(event.id, newStatus);
      await _productsRepository.toogleFavourite(
        state.token,
        state.userId,
        newStatus,
        event.id,
      );
      emit(state.copyWith(items: newItems, status: ProductsStatus.success));
    } catch (e) {
      final newItems =
          state.toogleFavouriteProduct(event.id, event.isFavourite);
      emit(state.copyWith(items: newItems, status: ProductsStatus.success));
      rethrow;
    }
  }

  Future<void> _onProductDeleted(
      ProductDeleted event, Emitter<ProductsState> emit) async {
    final productIndex = state.items.indexWhere((e) => e.id == event.id);
    final userProductIndex =
        state.userItems.indexWhere((e) => e.id == event.id);

    Product? product = state.items[productIndex];

    final newItems = state.items..removeAt(productIndex);
    final newUserItems = state.userItems..removeAt(userProductIndex);

    emit(state.copyWith(
        items: newItems,
        userItems: newUserItems,
        status: ProductsStatus.loading));

    final isRemovingSuccessfull =
        await _productsRepository.deleteProduct(state.token, event.id);
    if (isRemovingSuccessfull) {
      product = null;
      emit(state.copyWith(status: ProductsStatus.success));
    } else {
      newItems.insert(productIndex, product);
      newUserItems.insert(userProductIndex, product);

      emit(state.copyWith(
          items: newItems,
          userItems: newUserItems,
          status: ProductsStatus.failed));
      throw HttpException(message: 'Could not delete this product');
    }
  }

  Future<void> _onProductUpdated(
      ProductUpdated event, Emitter<ProductsState> emit) async {
    var productIndex = state.items.indexWhere((e) => e.id == event.product.id);

    if (productIndex >= 0) {
      emit(state.copyWith(status: ProductsStatus.loading));
      await _productsRepository.updateProduct(event.product, state.token);
      final newItems = state.items..[productIndex] = event.product;
      productIndex =
          state.userItems.indexWhere((e) => e.id == event.product.id);
      final newUserItems = state.userItems..[productIndex] = event.product;

      emit(state.copyWith(
          items: newItems,
          userItems: newUserItems,
          status: ProductsStatus.success));
    }
  }

  Future<void> _onProductAdded(
      ProductAdded event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(status: ProductsStatus.loading));
    final newProduct = await _productsRepository.addProduct(
        event.product, state.token, state.userId);
    final newItems = state.items..add(newProduct);
    final newUserItems = state.userItems..add(newProduct);

    emit(state.copyWith(
        items: newItems,
        userItems: newUserItems,
        status: ProductsStatus.success));
  }
}
