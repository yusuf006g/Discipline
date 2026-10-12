part of 'schedule_bloc.dart';

abstract class ScheduleEvent {}

class IsLoadedSchedule extends ScheduleEvent {}

class CreateSchedule extends ScheduleEvent {}

class UpdateSchedule extends ScheduleEvent {}

class DeleteSchedule extends ScheduleEvent {}