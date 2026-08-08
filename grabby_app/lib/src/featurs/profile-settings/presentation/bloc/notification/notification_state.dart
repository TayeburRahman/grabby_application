part of 'notification_bloc.dart';

@immutable
abstract class NotificationState {
  final List<NotificationModel> notifications;
  final String? errorMessage;

  const NotificationState({this.notifications = const [], this.errorMessage});
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {
  const NotificationLoading({super.notifications});
}

class NotificationLoaded extends NotificationState {
  const NotificationLoaded(List<NotificationModel> notifications)
      : super(notifications: notifications);
}

class NotificationError extends NotificationState {
  const NotificationError(String message, {super.notifications})
      : super(errorMessage: message);
}
