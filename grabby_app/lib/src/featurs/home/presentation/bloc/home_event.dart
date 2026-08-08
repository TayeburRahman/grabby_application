part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}
class ToggleThemeEvent extends HomeEvent {
  final bool isMapView;

  ToggleThemeEvent({required this.isMapView});
}