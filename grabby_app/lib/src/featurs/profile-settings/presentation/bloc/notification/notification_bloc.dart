import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/repositories/notification_repository_impl.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;

  NotificationBloc({required NotificationRepository repository})
      : _repository = repository,
        super(NotificationInitial()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
  }

  Future<void> _onFetchNotifications(
    FetchNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading(notifications: state.notifications));
    final response = await _repository.getNotifications();
    if (response.success && response.data != null) {
      emit(NotificationLoaded(response.data!));
    } else {
      emit(NotificationError(response.message, notifications: state.notifications));
    }
  }
}
