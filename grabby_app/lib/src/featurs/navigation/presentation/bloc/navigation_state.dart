part of 'navigation_bloc.dart';

@immutable
sealed class NavigationState {}

final class NavigationInitial extends NavigationState {
  final int currentIndex;

  NavigationInitial({this.currentIndex = 0});
}
final class NavigationChangeState extends NavigationState {
  final int currentIndex;

  NavigationChangeState({this.currentIndex = 0});
}