part of 'navigation_bloc.dart';
@immutable
sealed class NavigationEvent {}

class ChangeNavEvent extends NavigationEvent {
  final int currentIndex;

  ChangeNavEvent({required this.currentIndex});
}
