import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_available_appointments_usecase.dart';
import '../../domain/usecases/book_appointment_usecase.dart';
import 'appointment_event.dart';
import 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final GetAvailableAppointmentsUseCase getAvailableAppointmentsUseCase;
  final BookAppointmentUseCase bookAppointmentUseCase;

  AppointmentBloc({
    required this.getAvailableAppointmentsUseCase,
    required this.bookAppointmentUseCase,
  }) : super(AppointmentInitial()) {
    on<GetAvailableAppointmentsRequested>(_onGetAvailableAppointmentsRequested);
    on<BookAppointmentRequested>(_onBookAppointmentRequested);
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
