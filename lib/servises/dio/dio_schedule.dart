import 'package:discipline/servises/dio/dio_service.dart';

class DioSchedule {
  Future<List<dynamic>> getScheduls() async {
    final response =
    await DioService.dio.get('/api/schedules/');

    return response.data;
  }
}