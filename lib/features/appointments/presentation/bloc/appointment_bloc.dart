import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_available_appointments_usecase.dart';
import '../../domain/usecases/book_appointment_usecase.dart';
import '../../domain/usecases/get_admin_appointments_usecase.dart';
import '../../domain/usecases/update_appointment_status_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import 'appointment_event.dart';
import 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final GetAvailableAppointmentsUseCase getAvailableAppointmentsUseCase;
  final BookAppointmentUseCase bookAppointmentUseCase;
  final GetAdminAppointmentsUseCase getAdminAppointmentsUseCase;
  final UpdateAppointmentStatusUseCase updateAppointmentStatusUseCase;

  AppointmentBloc({
    required this.getAvailableAppointmentsUseCase,
    required this.bookAppointmentUseCase,
    required this.getAdminAppointmentsUseCase,
    required this.updateAppointmentStatusUseCase,
  }) : super(AppointmentInitial()) {
    on<GetAvailableAppointmentsRequested>(_onGetAvailableAppointmentsRequested);
    on<BookAppointmentRequested>(_onBookAppointmentRequested);
    on<GetAdminAppointmentsEvent>(_onGetAdminAppointments);
    on<UpdateAppointmentStatusEvent>(_onUpdateAppointmentStatus);
  }

  Future<void> _onGetAdminAppointments(
    GetAdminAppointmentsEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(AppointmentLoading());
    final result = await getAdminAppointmentsUseCase(NoParams());
    result.fold(
      (failure) => emit(AppointmentError(failure.message)),
      (appointments) => emit(AdminAppointmentsLoaded(appointments)),
    );
  }

  Future<void> _onUpdateAppointmentStatus(
    UpdateAppointmentStatusEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(AppointmentLoading());
    final result = await updateAppointmentStatusUseCase(
      UpdateAppointmentStatusParams(id: event.id, status: event.status),
    );
    result.fold(
      (failure) => emit(AppointmentError(failure.message)),
      (_) => emit(AppointmentStatusUpdated()),
    );
  }

  Future<void> _onGetAvailableAppointmentsRequested(
    GetAvailableAppointmentsRequested event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(AppointmentLoading());
    final result = await getAvailableAppointmentsUseCase(event.trackingNumber);
    result.fold(
      (failure) => emit(AppointmentError(failure.message)),
      (data) => emit(AppointmentsLoaded(data)),
    );
  }

  Future<void> _onBookAppointmentRequested(
    BookAppointmentRequested event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(AppointmentLoading());
    final result = await bookAppointmentUseCase(
      trackingNumber: event.trackingNumber,
      appointmentId: event.appointmentId,
      userId: event.userId,
    );
    result.fold(
      (failure) => emit(AppointmentError(failure.message)),
      (data) => emit(AppointmentBooked(data)),
    );
  }
}
