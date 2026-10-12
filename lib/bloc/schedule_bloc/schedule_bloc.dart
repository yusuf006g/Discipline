import 'package:bloc/bloc.dart';
import 'package:discipline/models/schedule_models/schedule_models.dart';
import 'package:discipline/servises/dio/dio_schedule.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final DioSchedule dioSchedule;

  ScheduleBloc(this.dioSchedule)
      : super(ScheduleInitial()) {
    on<IsLoadedSchedule>(_loadSchedules);
  }

  Future<void> _loadSchedules(
      IsLoadedSchedule event,
      Emitter<ScheduleState> emit,
      ) async {
    emit(ScheduleLoading());

    try {
      final data = await dioSchedule.getScheduls();

      final schedules = data
          .map<ScheduleModels>(
            (e) => ScheduleModels.fromJson(e),
      )
          .toList();

      emit(ScheduleLoaded(schedules));
    } catch (e) {
      emit(
        ScheduleError(
          e.toString(),
        ),
      );
    }
  }
}