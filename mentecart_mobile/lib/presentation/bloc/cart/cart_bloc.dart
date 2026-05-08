import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentecart_mobile/core/utils/logger.dart';
import 'package:mentecart_mobile/domain/usecases/cart/add_to_cart_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/cart/get_cart_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/cart/remove_from_cart_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/cart/update_cart_item_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUsecase getCartUsecase;
  final AddToCartUsecase addToCartUsecase;
  final UpdateCartItemUsecase updateCartItemUsecase;
  final RemoveFromCartUsecase removeFromCartUsecase;

  CartBloc({
    required this.getCartUsecase,
    required this.addToCartUsecase,
    required this.updateCartItemUsecase,
    required this.removeFromCartUsecase,
  }) : super(const CartInitial()) {
    on<GetCartEvent>(_onGetCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartItemEvent>(_onUpdateCartItem);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
  }

  Future<void> _onGetCart(
    GetCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());

    try {
      final result = await getCartUsecase(const NoParams());

      result.fold(
        (failure) => emit(CartError(failure.message)),
        (cart) {
          if (cart.items.isEmpty) {
            emit(const CartEmpty());
          } else {
            AppLogger.info('Loaded cart with ${cart.items.length} items');
            emit(CartLoaded(cart: cart));
          }
        },
      );
    } catch (e) {
      AppLogger.error('Get cart error: $e');
      emit(CartError('Failed to load cart'));
    }
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      final result = await addToCartUsecase(
        AddToCartParams(
          serviceId: event.serviceId,
          date: event.date,
          quantity: event.quantity,
        ),
      );

      result.fold(
        (failure) => emit(CartError(failure.message)),
        (cart) {
          AppLogger.info('Item added to cart');
          emit(CartLoaded(cart: cart));
        },
      );
    } catch (e) {
      AppLogger.error('Add to cart error: $e');
      emit(CartError('Failed to add item to cart'));
    }
  }

  Future<void> _onUpdateCartItem(
    UpdateCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      final result = await updateCartItemUsecase(
        UpdateCartItemParams(
          itemId: event.itemId,
          quantity: event.quantity,
        ),
      );

      result.fold(
        (failure) => emit(CartError(failure.message)),
        (cart) {
          AppLogger.info('Cart item updated');
          emit(CartLoaded(cart: cart));
        },
      );
    } catch (e) {
      AppLogger.error('Update cart item error: $e');
      emit(CartError('Failed to update cart item'));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      final result = await removeFromCartUsecase(
        RemoveFromCartParams(itemId: event.itemId),
      );

      result.fold(
        (failure) => emit(CartError(failure.message)),
        (cart) {
          if (cart.items.isEmpty) {
            emit(const CartEmpty());
          } else {
            AppLogger.info('Item removed from cart');
            emit(CartLoaded(cart: cart));
          }
        },
      );
    } catch (e) {
      AppLogger.error('Remove from cart error: $e');
      emit(CartError('Failed to remove item from cart'));
    }
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartEmpty());
  }
}