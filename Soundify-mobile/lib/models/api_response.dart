import 'dart:convert';
import 'package:http/http.dart';

class ApiResponse<T> {
  ApiResponseType apiResponseType;
  String details;
  T? value;

  ApiResponse(this.apiResponseType, this.details, this.value);

  factory ApiResponse.success(T value, String details) =>
      ApiResponse(ApiResponseType.success, details, value);

  factory ApiResponse.badRequest(String details) =>
      ApiResponse(ApiResponseType.badRequest, details, null);

  factory ApiResponse.unauthorized(String details) =>
      ApiResponse(ApiResponseType.badRequest, details, null);

  factory ApiResponse.notFound(String details) =>
      ApiResponse(ApiResponseType.notFound, details, null);

  factory ApiResponse.other(String details) =>
      ApiResponse(ApiResponseType.other, details, null);

  factory ApiResponse.fromHttpResponse(Response response) {
    final json = jsonDecode(response.body);
    final details = json['details'] as String;
    switch (response.statusCode) {
      case 200:
        final value = json['value'];
        return ApiResponse.success(value, details);
      case 404:
        return ApiResponse.notFound(details);
      case 400:
        return ApiResponse.badRequest(details);
      case 401:
        return ApiResponse.unauthorized(details);
      default:
        return ApiResponse.other(details);
    }
  }
}

class ApiResponseWithValue<T> {
  ApiResponseType apiResponseType;
  String details;
  T value;

  ApiResponseWithValue(this.apiResponseType, this.details, this.value);

  factory ApiResponseWithValue.fromApiResponse(ApiResponse<T> apiResponse) {
    final value = apiResponse.value;
    if (value != null) {
      return ApiResponseWithValue(
          apiResponse.apiResponseType, apiResponse.details, value);
    }
    throw Exception(
        "Tried to convert an ApiResponse to an ApiResponseWithValue although value is null");
  }
}

enum ApiResponseType { success, badRequest, notFound, unauthorized, other }
