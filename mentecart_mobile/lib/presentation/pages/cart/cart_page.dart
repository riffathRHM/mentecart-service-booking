import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentecart_mobile/core/constants/app_colors.dart';
import 'package:mentecart_mobile/core/constants/app_typography.dart';
import 'package:mentecart_mobile/core/constants/app_strings.dart';
import 'package:mentecart_mobile/core/constants/app_dimensions.dart';
import 'package:mentecart_mobile/core/extensions/context_extensions.dart';
import 'package:mentecart_mobile/presentation/bloc/cart/cart_bloc.dart';
import 'package:mentecart_mobile/presentation/bloc/cart/cart_event.dart';
import 'package:mentecart_mobile/presentation/bloc/cart/cart_state.dart';
import 'package:mentecart_mobile/presentation/widgets/cart/cart_item_widget.dart';
import 'package:mentecart_mobile/presentation/widgets/cart/cart_summary.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(const GetCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.cart),
        elevation: 0,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CartLoaded) {
            final cart = state.cart;

            if (cart.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: AppColors.grey.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.cartEmpty,
                      style: AppTypography.headingMedium.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/home');
                      },
                      child: const Text(AppStrings.startShopping),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(
                      AppDimensions.paddingDefault,
                    ),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return CartItemWidget(
                        item: item,
                        onRemove: () {
                          context.read<CartBloc>().add(
                                RemoveFromCartEvent(itemId: item.id),
                              );
                        },
                        onQuantityChanged: (quantity) {
                          context.read<CartBloc>().add(
                                UpdateCartItemEvent(
                                  itemId: item.id,
                                  quantity: quantity,
                                ),
                              );
                        },
                      );
                    },
                  ),
                ),
                CartSummaryWidget(
                  cart: cart,
                  onCheckout: () {
                    Navigator.of(context).pushNamed('/checkout');
                  },
                ),
              ],
            );
          } else if (state is CartError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}