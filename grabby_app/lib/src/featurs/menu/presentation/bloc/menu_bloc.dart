import 'dart:developer';
import 'dart:io';
import '../../../../src_export.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository _menuRepository;

  MenuBloc(this._menuRepository) : super(MenuState()) {
    on<GetMenuCategoriesEvent>(_onGetMenuCategories);
    on<CreateMenuCategoryEvent>(_onCreateMenuCategory);
    on<DeleteMenuCategoryEvent>(_onDeleteMenuCategory);
    on<GetMenuItemsEvent>(_onGetMenuItems);
    on<CreateMenuItemEvent>(_onCreateMenuItem);
    on<UpdateMenuItemEvent>(_onUpdateMenuItem);
    on<DeleteMenuItemEvent>(_onDeleteMenuItem);
  }

  Future<void> _onGetMenuItems(
    GetMenuItemsEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(state.copyWith(status: MenuStatus.loading));
    try {
      final response = await _menuRepository.getMenuItems(
        page: event.page,
        limit: event.limit,
        searchTerm: event.searchTerm,
        categoryId: event.categoryId,
      );
      if (response.success && response.data != null) {
        emit(
          state.copyWith(
            status: MenuStatus.success,
            items: response.data!.data,
            meta: response.data!.meta,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: MenuStatus.error,
            errorMessage: response.message,
          ),
        );
      }
    } on ApiException catch (e) {
      emit(state.copyWith(status: MenuStatus.error, errorMessage: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          status: MenuStatus.error,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  Future<void> _onGetMenuCategories(
    GetMenuCategoriesEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(state.copyWith(status: MenuStatus.loading));
    try {
      final response = await _menuRepository.getMenuCategories();
      if (response.success && response.data != null) {
        emit(
          state.copyWith(
            status: MenuStatus.success,
            categories: response.data!,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: MenuStatus.error,
            errorMessage: response.message,
          ),
        );
      }
    } on ApiException catch (e) {
      emit(state.copyWith(status: MenuStatus.error, errorMessage: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          status: MenuStatus.error,
          errorMessage: 'Something went wrong.',
        ),
      );
    }
  }

  Future<void> _onCreateMenuCategory(
    CreateMenuCategoryEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(state.copyWith(status: MenuStatus.loading));
    try {
      final response = await _menuRepository.createMenuCategory(event.name);
      if (response.success && response.data != null) {
        final updatedCategories = List<MenuCategoryModel>.from(state.categories)
          ..add(response.data!);

        emit(
          state.copyWith(
            status: MenuStatus.success,
            successMessage: response.message,
            categories: updatedCategories,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: MenuStatus.error,
            errorMessage: response.message,
          ),
        );
      }
    } on ApiException catch (e) {
      log(e.toString());
      emit(state.copyWith(status: MenuStatus.error, errorMessage: e.message));
    } catch (e) {
      log(e.toString());
      emit(
        state.copyWith(
          status: MenuStatus.error,
          errorMessage: 'Something went wrong.',
        ),
      );
    }
  }

  Future<void> _onDeleteMenuCategory(
    DeleteMenuCategoryEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(state.copyWith(status: MenuStatus.loading));
    try {
      final response = await _menuRepository.deleteMenuCategory(event.id);
      if (response.success) {
        final updatedCategories = await _menuRepository.getMenuCategories();
        emit(
          state.copyWith(
            status: MenuStatus.success,
            successMessage: response.message,
            categories: updatedCategories.data ?? state.categories,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: MenuStatus.error,
            errorMessage: response.message,
          ),
        );
      }
    } on ApiException catch (e) {
      emit(state.copyWith(status: MenuStatus.error, errorMessage: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          status: MenuStatus.error,
          errorMessage: 'Something went wrong.',
        ),
      );
    }
  }

  Future<void> _onCreateMenuItem(
    CreateMenuItemEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(state.copyWith(status: MenuStatus.loading));
    try {
      final response = await _menuRepository.createMenu(
        itemName: event.itemName,
        categoryId: event.categoryId,
        price: event.price,
        description: event.description,
        stampActive: event.stampActive,
        isAvailable: event.isAvailable,
        additionalItems: event.additionalItems,
        image: event.image,
      );
      if (response.success) {
        // Refresh items list
        final updatedItems = await _menuRepository.getMenuItems();
        emit(
          state.copyWith(
            status: MenuStatus.success,
            successMessage: response.message,
            items: updatedItems.data?.data ?? state.items,
            meta: updatedItems.data?.meta ?? state.meta,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: MenuStatus.error,
            errorMessage: response.message,
          ),
        );
      }
    } on ApiException catch (e) {
      emit(state.copyWith(status: MenuStatus.error, errorMessage: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          status: MenuStatus.error,
          errorMessage: 'Something went wrong.',
        ),
      );
    }
  }

  Future<void> _onUpdateMenuItem(
    UpdateMenuItemEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(state.copyWith(status: MenuStatus.loading));
    try {
      final response = await _menuRepository.updateMenu(
        menuId: event.menuId,
        itemName: event.itemName,
        categoryId: event.categoryId,
        price: event.price,
        description: event.description,
        stampActive: event.stampActive,
        isAvailable: event.isAvailable,
        additionalItems: event.additionalItems,
        image: event.image,
      );
      if (response.success) {
        final updatedItems = await _menuRepository.getMenuItems();
        emit(
          state.copyWith(
            status: MenuStatus.success,
            successMessage: response.message,
            items: updatedItems.data?.data ?? state.items,
            meta: updatedItems.data?.meta ?? state.meta,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: MenuStatus.error,
            errorMessage: response.message,
          ),
        );
      }
    } on ApiException catch (e) {
      emit(state.copyWith(status: MenuStatus.error, errorMessage: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          status: MenuStatus.error,
          errorMessage: 'Something went wrong.',
        ),
      );
    }
  }

  Future<void> _onDeleteMenuItem(
    DeleteMenuItemEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(state.copyWith(status: MenuStatus.loading));
    try {
      final response = await _menuRepository.deleteMenu(event.id);
      if (response.success) {
        final updatedItems = await _menuRepository.getMenuItems();
        emit(
          state.copyWith(
            status: MenuStatus.success,
            successMessage: response.message,
            items: updatedItems.data?.data ?? state.items,
            meta: updatedItems.data?.meta ?? state.meta,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: MenuStatus.error,
            errorMessage: response.message,
          ),
        );
      }
    } on ApiException catch (e) {
      emit(state.copyWith(status: MenuStatus.error, errorMessage: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          status: MenuStatus.error,
          errorMessage: 'Something went wrong.',
        ),
      );
    }
  }
}
