import 'dart:io';
import '../../../../src_export.dart';

abstract class MenuRepository {
  Future<ApiResponse<List<MenuCategoryModel>>> getMenuCategories();
  Future<ApiResponse<MenuCategoryModel>> createMenuCategory(String name);
  Future<ApiResponse<void>> deleteMenuCategory(String id);
  Future<ApiResponse<MenuShopResponseModel>> getMenuItems({
    int page = 1,
    int limit = 10,
    String? searchTerm,
    String? categoryId,
  });
  Future<ApiResponse<void>> createMenu({
    required String itemName,
    required String categoryId,
    required double price,
    required String description,
    required bool stampActive,
    required bool isAvailable,
    required List<CustomizationGroupModel> additionalItems,
    File? image,
  });
  Future<ApiResponse<void>> updateMenu({
    required String menuId,
    String? itemName,
    String? categoryId,
    double? price,
    String? description,
    bool? stampActive,
    bool? isAvailable,
    List<CustomizationGroupModel>? additionalItems,
    File? image,
  });
  Future<ApiResponse<void>> deleteMenu(String id);
}

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;

  MenuRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResponse<List<MenuCategoryModel>>> getMenuCategories() {
    return remoteDataSource.getMenuCategories();
  }

  @override
  Future<ApiResponse<MenuCategoryModel>> createMenuCategory(String name) {
    return remoteDataSource.createMenuCategory(name);
  }

  @override
  Future<ApiResponse<void>> deleteMenuCategory(String id) {
    return remoteDataSource.deleteMenuCategory(id);
  }

  @override
  Future<ApiResponse<MenuShopResponseModel>> getMenuItems({
    int page = 1,
    int limit = 10,
    String? searchTerm,
    String? categoryId,
  }) {
    return remoteDataSource.getMenuItems(
      page: page,
      limit: limit,
      searchTerm: searchTerm,
      categoryId: categoryId,
    );
  }

  @override
  Future<ApiResponse<void>> createMenu({
    required String itemName,
    required String categoryId,
    required double price,
    required String description,
    required bool stampActive,
    required bool isAvailable,
    required List<CustomizationGroupModel> additionalItems,
    File? image,
  }) {
    return remoteDataSource.createMenu(
      itemName: itemName,
      categoryId: categoryId,
      price: price,
      description: description,
      stamp: stampActive,
      isAvailable: isAvailable,
      additionalItems: additionalItems,
      image: image,
    );
  }

  @override
  Future<ApiResponse<void>> updateMenu({
    required String menuId,
    String? itemName,
    String? categoryId,
    double? price,
    String? description,
    bool? stampActive,
    bool? isAvailable,
    List<CustomizationGroupModel>? additionalItems,
    File? image,
  }) {
    return remoteDataSource.updateMenu(
      menuId: menuId,
      itemName: itemName,
      categoryId: categoryId,
      price: price,
      description: description,
      stamp: stampActive,
      isAvailable: isAvailable,
      additionalItems: additionalItems,
      image: image,
    );
  }

  @override
  Future<ApiResponse<void>> deleteMenu(String id) {
    return remoteDataSource.deleteMenu(id);
  }
}
