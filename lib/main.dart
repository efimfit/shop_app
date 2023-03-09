import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shop_app/shop_app.dart';
import 'package:shop_app/auth/auth.dart';
import 'package:shop_app/orders/orders.dart';
import 'package:shop_app/products/products.dart';

void main() {
  final firebaseAuthApi = FirebaseAuthApi();
  final firebaseRealtimeApi = FirebaseRealtimeApi();

  return runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(create: (context) => AuthRepository(firebaseAuthApi)),
      RepositoryProvider(
          create: (context) => ProductsRepository(firebaseRealtimeApi)),
      RepositoryProvider(
          create: (context) => OrdersRepository(firebaseRealtimeApi)),
    ],
    child: const ShopApp(),
  ));
}
