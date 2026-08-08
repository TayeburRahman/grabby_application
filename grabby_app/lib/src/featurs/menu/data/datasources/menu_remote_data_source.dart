import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import '../../../../src_export.dart';

abstract class MenuRemoteDataSource {
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
    required bool stamp,
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
    bool? stamp,
    bool? isAvailable,
    List<CustomizationGroupModel>? additionalItems,
    File? image,
  });
  Future<ApiResponse<void>> deleteMenu(String id);
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final ApiService apiService;

  MenuRemoteDataSourceImpl(this.apiService);

  @override
  Future<ApiResponse<List<MenuCategoryModel>>> getMenuCategories() async {
    return await apiService.get<List<MenuCategoryModel>>(
      ApiEndpoints.getMenuCategories,
      fromJson: (json) => (json['data'] as List)
          .map((e) => MenuCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResponse<MenuCategoryModel>> createMenuCategory(String name) async {
    return await apiService.post<MenuCategoryModel>(
      ApiEndpoints.createMenuCategory,
      data: {"name": name},
      fromJson: (json) =>
          MenuCategoryModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<void>> deleteMenuCategory(String id) async {
    return await apiService.delete<void>(ApiEndpoints.deleteMenuCategory(id));
  }

  @override
  Future<ApiResponse<MenuShopResponseModel>> getMenuItems({
    int page = 1,
    int limit = 10,
    String? searchTerm,
    String? categoryId,
  }) async {
    final Map<String, dynamic> queryParameters = {"page": page, "limit": limit};

    if (searchTerm != null && searchTerm.isNotEmpty) {
      queryParameters["searchTerm"] = searchTerm;
    }

    if (categoryId != null && categoryId.isNotEmpty) {
      queryParameters["category"] = categoryId;
    }

    return await apiService.get<MenuShopResponseModel>(
      ApiEndpoints.getShopMenuItems,
      queryParameters: queryParameters,
      fromJson: (json) =>
          MenuShopResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<void>> createMenu({
    required String itemName,
    required String categoryId,
    required double price,
    required String description,
    required bool stamp,
    required bool isAvailable,
    required List<CustomizationGroupModel> additionalItems,
    File? image,
  }) async {
    final Map<String, dynamic> data = {
      "itemName": itemName,
      "category": categoryId,
      "price": price,
      "description": description,
      "stampActive": stamp,
      "isAvailable": isAvailable,
      "additionalItems": jsonEncode(
        additionalItems.map((e) => e.toJson()).toList(),
      ),
    };

    log("Create Menu Request Body: $data");

    if (image != null) {
      data["image"] = await dio.MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      );
    }

    final formData = dio.FormData.fromMap(data);

    return await apiService.post<void>(ApiEndpoints.createMenu, data: formData);
  }

  @override
  Future<ApiResponse<void>> updateMenu({
    required String menuId,
    String? itemName,
    String? categoryId,
    double? price,
    String? description,
    bool? stamp,
    bool? isAvailable,
    List<CustomizationGroupModel>? additionalItems,
    File? image,
  }) async {
    final Map<String, dynamic> data = {};

    if (itemName != null) data["itemName"] = itemName;
    if (categoryId != null) data["category"] = categoryId;
    if (price != null) data["price"] = price;
    if (description != null) data["description"] = description;
    if (stamp != null) data["stampActive"] = stamp;
    if (isAvailable != null) data["isAvailable"] = isAvailable;
    if (additionalItems != null) {
      data["additionalItems"] = jsonEncode(
        additionalItems.map((e) => e.toJson()).toList(),
      );
    }

    log("Update Menu Request Body: $data");

    if (image != null) {
      data["image"] = await dio.MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      );
    }

    final formData = dio.FormData.fromMap(data);

    return await apiService.patch<void>(
      ApiEndpoints.updateMenu(menuId),
      data: formData,
    );
  }

  @override
  Future<ApiResponse<void>> deleteMenu(String id) async {
    return await apiService.delete<void>(ApiEndpoints.deleteMenu(id));
  }
}
