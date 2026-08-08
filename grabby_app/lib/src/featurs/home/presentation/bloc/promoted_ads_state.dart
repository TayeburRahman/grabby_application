part of 'promoted_ads_bloc.dart';

abstract class PromotedAdsState {}

class PromotedAdsInitial extends PromotedAdsState {}
class PromotedAdsLoading extends PromotedAdsState {}
class PromotedAdsLoaded extends PromotedAdsState {
  final List<ShopAdModel> ads;
  PromotedAdsLoaded(this.ads);
}
class PromotedAdsError extends PromotedAdsState {
  final String message;
  PromotedAdsError(this.message);
}
