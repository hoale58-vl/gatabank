import 'package:dio/dio.dart';
import 'package:gatabank/api.dart';
import 'package:mockito/mockito.dart';

class MockAPI extends Mock implements API {}

successResponse(Map<String, dynamic> data) {
  return (_) => Future.value(Response(statusCode: 200, data: data));
}

errorResponse({statusCode = 400}) {
  return (_) => Future.value(Response(
        statusCode: statusCode,
      ));
}
