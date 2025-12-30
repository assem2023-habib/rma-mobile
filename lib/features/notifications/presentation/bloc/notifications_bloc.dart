import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../domain/entities/notification_entity.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsRepository repository;

  NotificationsBloc({required this.repository})
    : super(NotificationsInitial()) {
    on<GetNotificationsEvent>(_onGetNotifications);
    on<MarkNotificationAsReadEvent>(_onMarkAsRead);
    on<MarkAllNotificationsAsReadEvent>(_onMarkAllAsRead);
    on<DeleteNotificationEvent>(_onDelete);
    on<NotificationReceivedEvent>(_onNotificationReceived);
  }

  Future<void> _onNotificationReceived(
    NotificationReceivedEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      final updatedNotifications = List<NotificationEntity>.from(
        currentState.notifications,
      )..insert(0, event.notification);

      emit(
        NotificationsLoaded(
          notifications: updatedNotifications,
          unreadCount: currentState.unreadCount + 1,
        ),
      );
    } else {
      // If not loaded yet, we could trigger a reload or manually create state.
      // For simplicity, let's just trigger a reload if we are not in loaded state,
      // OR we can manually emit loaded state if we want to be fancy.
      // But usually if not loaded, the next GetNotificationsEvent will fetch it.
      // Let's at least try to refresh if we are in Initial.
      add(GetNotificationsEvent());
    }
  }

  Future<void> _onGetNotifications(
    GetNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading());
    final result = await repository.getNotifications();
    result.fold((failure) => emit(NotificationsError(failure.message)), (
      notifications,
    ) {
      final unreadCount = notifications.where((n) => n.isRead == false).length;
      emit(
        NotificationsLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
        ),
      );
    });
  }

  Future<void> _onMarkAsRead(
    MarkNotificationAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      final updatedNotifications = currentState.notifications.map((n) {
        if (n.id == event.id) {
          return n.copyWith(readAt: DateTime.now());
        }
        return n;
      }).toList();

      emit(
        NotificationsLoaded(
          notifications: updatedNotifications,
          unreadCount: updatedNotifications
              .where((n) => n.isRead == false)
              .length,
        ),
      );
      await repository.markAsRead(event.id);
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllNotificationsAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      final updatedNotifications = currentState.notifications.map((n) {
        return n.copyWith(readAt: DateTime.now());
      }).toList();

      emit(
        NotificationsLoaded(
          notifications: updatedNotifications,
          unreadCount: 0,
        ),
      );

      await repository.markAllAsRead();
    }
  }

  Future<void> _onDelete(
    DeleteNotificationEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      final updatedNotifications = currentState.notifications
          .where((n) => n.id != event.id)
          .toList();

      final result = await repository.deleteNotification(event.id);

      result.fold((failure) => emit(NotificationsError(failure.message)), (
        message,
      ) {
        emit(
          NotificationsLoaded(
            notifications: updatedNotifications,
            unreadCount: updatedNotifications
                .where((n) => n.isRead == false)
                .length,
            successMessage: message,
          ),
        );
      });
    }
  }
}
