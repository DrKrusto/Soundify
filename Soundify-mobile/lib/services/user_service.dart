import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:soundify/models/api_response.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

import '../main.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<ApiResponse<String>> loginUser(
      String email, String password) async {
    final url = Uri.parse('${MyApp.serverUrl}/Api/User/LoginUser');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});

    final response = await http.post(url, headers: headers, body: body);
    final data = jsonDecode(response.body);
    final details = data['details'] as String;

    if (response.statusCode == 200) {
      final jwt = data['value'] as String;
      return ApiResponse.success(jwt, details);
    } else if (response.statusCode == 401) {
      return ApiResponse.unauthorized(details);
    }
    return ApiResponse.badRequest(details);
  }

  static String getDefaultImageUrl(String baseUrl) =>
      "$baseUrl/images/users/default.jpg";

  static Future<XFile?> searchForImageOnDevice() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  static Future<ApiResponse<User>> getUserFromApi(
      {String? userId, String? email, String? username}) async {
    final url = Uri.parse('${MyApp.serverUrl}/Api/User/GetUser');

    final queryParameters = <String, dynamic>{
      if (userId != null) 'UserId': userId,
      if (email != null) 'Email': email,
      if (username != null) 'Username': username,
    };

    final uri = url.replace(queryParameters: queryParameters);

    try {
      final response = await http.get(uri);
      final data = jsonDecode(response.body);
      final details = data['details'] as String;
      if (response.statusCode == 200) {
        final user = User.fromJson(data['value']);
        return ApiResponse.success(user, details);
      } else if (response.statusCode == 404) {
        return ApiResponse.notFound(details);
      } else {
        return ApiResponse.badRequest(details);
      }
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  static Future<ApiResponse<String>> createUser(
      String email, String username, String password) async {
    final url = Uri.parse('${MyApp.serverUrl}/Api/User/CreateUser');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(
        {'username': username, 'email': email, 'password': password});

    final response = await http.post(url, headers: headers, body: body);
    final data = jsonDecode(response.body);
    final details = data['details'] as String;

    if (response.statusCode == 200) {
      return ApiResponse.success(email, details);
    }

    return ApiResponse.badRequest(details);
  }

  static Future<ApiResponse<String>> uploadProfilePicture(
      String userId, XFile image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${MyApp.serverUrl}/Api/User/UploadProfilePicture'),
    );

    request.fields['UserId'] = userId;
    request.files.add(await http.MultipartFile.fromPath('Image', image.path,
        contentType:
            MediaType('image', path.extension(image.name).substring(1))));

    var response = await request.send();

    if (response.statusCode == 200) {
      return ApiResponse.success('done', 'Image uploaded successfully');
    }

    return ApiResponse.badRequest('Couldn\'t upload this image');
  }
}
