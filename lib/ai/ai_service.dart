import 'dart:convert';

import 'package:dio/dio.dart';

class AIService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://nurmatovy654-disipline-ai.hf.space',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 180),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<void> init() async {
    // Модель находится на Hugging Face.
    // На телефоне ничего загружать не нужно.
  }

  Future<String> ask(String text) async {
    try {
      // 1. Отправляем запрос в Gradio
      final response = await _dio.post(
        '/gradio_api/call/chat',
        data: {
          'data': [text],
        },
      );

      final eventId = response.data['event_id'];

      if (eventId == null) {
        throw Exception(
          'Hugging Face не вернул event_id.\n'
              'Ответ: ${response.data}',
        );
      }

      // 2. Получаем SSE-поток
      final result = await _dio.get<String>(
        '/gradio_api/call/chat/$eventId',
        options: Options(
          responseType: ResponseType.plain,
        ),
      );

      final raw = result.data ?? '';

      print('HF SSE RESPONSE: $raw');

      String? completeData;

      final lines = raw.split('\n');

      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();

        if (line == 'event: complete') {
          for (int j = i + 1; j < lines.length; j++) {
            final dataLine = lines[j].trim();

            if (dataLine.startsWith('data:')) {
              completeData = dataLine.substring(5).trim();
              break;
            }
          }

          break;
        }

        if (line == 'event: error') {
          for (int j = i + 1; j < lines.length; j++) {
            final dataLine = lines[j].trim();

            if (dataLine.startsWith('data:')) {
              throw Exception(
                'Qwen error: ${dataLine.substring(5).trim()}',
              );
            }
          }
        }
      }

      if (completeData == null) {
        throw Exception(
          'Не получен event: complete.\n'
              'Ответ:\n$raw',
        );
      }

      final decoded = jsonDecode(completeData);

      if (decoded is List && decoded.isNotEmpty) {
        return decoded.first.toString();
      }

      if (decoded is String) {
        return decoded;
      }

      throw Exception(
        'Неизвестный формат ответа Qwen: $decoded',
      );
    } on DioException catch (e) {
      print('HF DIO ERROR: ${e.message}');
      print('HF STATUS: ${e.response?.statusCode}');
      print('HF DATA: ${e.response?.data}');
      print('HF URL: ${e.requestOptions.uri}');

      throw Exception(
        'Ошибка Hugging Face: ${e.response?.statusCode ?? e.type}',
      );
    } catch (e) {
      print('HF AI ERROR: $e');
      rethrow;
    }
  }

  Future<void> dispose() async {}
}