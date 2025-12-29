import 'package:equatable/equatable.dart';
import '../../domain/entities/notification_entity.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class GetNotificationsEvent extends NotificationsEvent {}

class MarkNotificationAsReadEvent extends NotificationsEvent {
  final int id;
  const MarkNotificationAsReadEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class MarkAllNotificationsAsReadEvent extends NotificationsEvent {}

class DeleteNotificationEvent extends NotificationsEvent {
  final int id;
  const DeleteNotificationEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class NewNotificationReceivedEvent extends NotificationsEvent {
  final NotificationEntity notification;
  const NewNotificationReceivedEvent(this.notification);

  @override
  List<Object?> get props => [notification];
}
