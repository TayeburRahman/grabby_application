part of 'promotion_bloc.dart';

abstract class PromotionEvent {}

class GetPromotionsEvent extends PromotionEvent {
  final String? searchTerm;
  final int? page;
  final int? limit;

  GetPromotionsEvent({
    this.searchTerm,
    this.page = 1,
    this.limit = 10,
  });
}

class CreatePromotionEvent extends PromotionEvent {
  final Map<String, dynamic> data;

  CreatePromotionEvent(this.data);
}

class UpdatePromotionEvent extends PromotionEvent {
  final String id;
  final Map<String, dynamic> data;

  UpdatePromotionEvent(this.id, this.data);
}

class DeletePromotionEvent extends PromotionEvent {
  final String id;

  DeletePromotionEvent(this.id);
}

class FetchUpcomingEventsEvent extends PromotionEvent {}