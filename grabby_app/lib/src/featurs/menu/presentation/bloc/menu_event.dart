part of 'menu_bloc.dart';

abstract class MenuEvent {}

class GetMenuCategoriesEvent extends MenuEvent {}

class CreateMenuCategoryEvent extends MenuEvent {
  final String name;
  CreateMenuCategoryEvent(this.name);
}

class DeleteMenuCategoryEvent extends MenuEvent {
  final String id;
  DeleteMenuCategoryEvent(this.id);
}

class GetMenuItemsEvent extends MenuEvent {
  final int page;
  final int limit;
  final String? searchTerm;
  final String? categoryId;

  GetMenuItemsEvent({
    this.page = 1,
    this.limit = 10,
    this.searchTerm,
    this.categoryId,
  });
}

class CreateMenuItemEvent extends MenuEvent {
  final String itemName;
  final String categoryId;
  final double price;
  final String description;
  final bool stampActive;
  final bool isAvailable;
  final List<CustomizationGroupModel> additionalItems;
  final File? image;

  CreateMenuItemEvent({
    required this.itemName,
    required this.categoryId,
    required this.price,
    required this.description,
    required this.stampActive,
    required this.isAvailable,
    required this.additionalItems,
    this.image,
  });
}

class UpdateMenuItemEvent extends MenuEvent {
  final String menuId;
  final String? itemName;
  final String? categoryId;
  final double? price;
  final String? description;
  final bool stampActive;
  final bool? isAvailable;
  final List<CustomizationGroupModel>? additionalItems;
  final File? image;

  UpdateMenuItemEvent({
    required this.menuId,
    this.itemName,
    this.categoryId,
    this.price,
    this.description,
    this.stampActive = false,
    this.isAvailable,
    this.additionalItems,
    this.image,
  });
}

class DeleteMenuItemEvent extends MenuEvent {
  final String id;
  DeleteMenuItemEvent(this.id);
}
