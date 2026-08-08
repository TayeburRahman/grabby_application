part of 'promotion_bloc.dart';

abstract class PromotionState {}

class PromotionInitial extends PromotionState {}

class PromotionLoading extends PromotionState {}

class PromotionsLoaded extends PromotionState {
  final PromotionListResponse data;
  final List<UpcomingEventModel> upcomingEvents;

  PromotionsLoaded(this.data, {this.upcomingEvents = const []});
}

class UpcomingEventsLoaded extends PromotionState {
  final List<UpcomingEventModel> upcomingEvents;

  UpcomingEventsLoaded(this.upcomingEvents);
}

class PromotionOperationSuccess extends PromotionState {
  final String message;

  PromotionOperationSuccess(this.message);
}

class PromotionError extends PromotionState {
  final String message;

  PromotionError(this.message);
}