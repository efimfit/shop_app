import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shop_app/auth/auth.dart';
import 'package:shop_app/orders/orders.dart';
import 'package:shop_app/products/products.dart';
import 'package:shop_app/app/app.dart';
import 'package:shop_app/cart/cart.dart';
import 'package:shop_app/user_products/user_products.dart';

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthBloc(authRepository: context.read<AuthRepository>())
                ..add(const AutoLoginSubmitted()),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => ProductsBloc(
            productsRepository: context.read<ProductsRepository>(),
            authBloc: context.read<AuthBloc>(),
          ),
        ),
        BlocProvider(
          create: (context) => CartBloc(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => OrdersBloc(
            ordersRepository: context.read<OrdersRepository>(),
            authBloc: context.read<AuthBloc>(),
          ),
        ),
      ],
      child: const ShopAppView(),
    );
  }
}

class ShopAppView extends StatelessWidget {
  const ShopAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Shopping app',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
            ),
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
            }),
          ),
          home: state.isAuth
              ? const ProductsOverview()
              : state.status == AuthStatus.loading
                  ? const SplashPage()
                  : const AuthPage(),
          routes: {
            UserProducts.routeName: (context) => const UserProducts(),
            ProductDetails.routeName: (context) => const ProductDetails(),
            EditProduct.routeName: (context) => const EditProduct(),
            CartPage.routeName: (context) => const CartPage(),
            OrdersPage.routeName: (context) => const OrdersPage(),
          },
        );
      },
    );
  }
}
