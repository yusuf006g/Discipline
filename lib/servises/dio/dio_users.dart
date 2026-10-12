import 'package:discipline/servises/dio/dio_service.dart';

class DioUsers {
  Future<Map<String, dynamic>> getUser() async {
    final response = await DioService.dio.get('/api/users/');

    final List users = response.data;

    return users.first;
  }
}