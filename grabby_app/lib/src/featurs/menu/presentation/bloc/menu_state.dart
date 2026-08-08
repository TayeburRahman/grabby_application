part of 'menu_bloc.dart';

enum MenuStatus { initial, loading, success, error }

class MenuState {
  final List<MenuCategoryModel> categories;
  final List<MenuItemModel> items;
  final PaginationMeta? meta;
  final MenuStatus status;
  final String? errorMessage;
  final String? successMessage;

  MenuState({
    this.categories = const [],
    this.items = const [],
    this.meta,
    this.status = MenuStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  MenuState copyWith({
    List<MenuCategoryModel>? categories,
    List<MenuItemModel>? items,
    PaginationMeta? meta,
    MenuStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return MenuState(
      categories: categories ?? this.categories,
      items: items ?? this.items,
      meta: meta ?? this.meta,
      status: status ?? this.status,
      errorMessage: errorMessage, // Reset error on new state unless provided
      successMessage: successMessage, // Reset success on new state unless provided
    );
  }
}
