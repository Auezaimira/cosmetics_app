import 'dart:convert';
import 'dart:io';

import 'package:cosmetics_app/models/api_response_models.dart';
import 'package:cosmetics_app/utils/logger.dart';
import 'package:cosmetics_app/utils/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

import '../models/notes.model.dart';
import '../models/recommendations.model.dart';
import '../models/user.model.dart';
import '../models/user_preferences.model.dart';

class ApiService {
  // static const String baseUrl = 'http://185.4.180.214:4444';
  static const String baseUrl = 'http://localhost:4000';

  String get apiKey {
    final apiKey = dotenv.env['OPEN_AI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key is not defined in the environment variables');
    }
    return apiKey;
  }

  static Future<bool> registerUser({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final Uri url = Uri.parse('$baseUrl/auth/register');
    final Map<String, dynamic> payload = {
      'email': email,
      'password': password,
      'fullName': fullName
    };
    return await http
        .post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(payload),
    )
        .then((res) async {
      if (res.statusCode >= 400) {
        throw Exception('Server responded with an error: ${res.statusCode}');
      }

      final responseJson = json.decode(res.body);
      final accessTokenResponse = TokenResponse.fromJson(responseJson);

      TokenService.saveToken(accessTokenResponse.accessToken);

      return true;
    }).catchError((err) => throw Exception('Error has occurred $err'));
  }

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    final Uri url = Uri.parse('$baseUrl/auth/login');
    final Map<String, dynamic> payload = {
      'email': email,
      'password': password,
    };
    return await http
        .post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(payload),
    )
        .then((res) async {
      if (res.statusCode >= 400) {
        throw Exception('Server responded with an error: ${res.statusCode}');
      }

      final responseJson = json.decode(res.body);
      final accessTokenResponse = TokenResponse.fromJson(responseJson);

      TokenService.saveToken(accessTokenResponse.accessToken);

      return true;
    }).catchError((err) => throw Exception('Error has occurred $err'));
  }

  Future<String> getResponse(String prompt) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    final apiKey = this.apiKey;

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'model': 'gpt-4',
        'messages': [
          {
            'role': 'system',
            'content':
                'Здравствуйте! Я рад помочь вам с профессиональными советами по уходу за телом.'
          },
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    final decodedBody = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      final data = json.decode(decodedBody);
      final lastMessage = data['choices'][0]['message']['content'];
      return lastMessage;
    } else {
      throw Exception('Failed to get response from OpenAI: ${response.body}');
    }
  }

  static Future getCurrentUser() async {
    final Uri url = Uri.parse('$baseUrl/users/current');
    final token = await TokenService.getToken();
    MyLogger.log.d('token: $token');
    final response =
        await http.get(url, headers: {"Authorization": token as String});
    if (response.statusCode == 200) {
      MyLogger.log.i('User: ${User.fromJson(json.decode(response.body))}');
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  static Future getRecommendations(String userId) async {
    final token = await TokenService.getToken();

    final Uri url = Uri.parse('$baseUrl/recommendations/$userId');

    final response =
        await http.get(url, headers: {"Authorization": 'Bearer $token'});

    if (response.statusCode == 200) {
      MyLogger.log.i('Recommendations: ${json.decode(response.body)}');
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Recommendations.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

  static Future uploadProfileImage(String filePath) async {
    final token = await TokenService.getToken();

    final uri = Uri.parse('$baseUrl/users/profile-image');
    final request = http.MultipartRequest('PATCH', uri);

    String? mimeType = lookupMimeType(filePath);

    File file = File(filePath);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    request.files.add(
      http.MultipartFile(
        'file',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: basename(file.path),
        contentType: mimeType != null
            ? MediaType.parse(mimeType)
            : MediaType('application', 'octet-stream'),
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      final String responseBody = await response.stream.bytesToString();
      final jsonData = User.fromJson(json.decode(responseBody));
      MyLogger.log.i('Изображение успешно загружено');
      return jsonData;
    } else {
      throw Exception(
          'Ошибка при загрузке изображения: ${response.statusCode}');
    }
  }

  static Future updateUser(Map<String, dynamic> userData) async {
    final token = await TokenService.getToken();

    final uri = Uri.parse('$baseUrl/users/profile');

    final response = await http.patch(uri,
        headers: {"Authorization": 'Bearer $token'}, body: userData);

    if (response.statusCode == 200) {
      final updatedUserData = json.decode(response.body);
      MyLogger.log.i('Профиль успешно обновлен $updatedUserData');
      return User.fromJson(updatedUserData);
    } else {
      throw Exception('Failed to load user');
    }
  }

  static Future logout() async {
    final token = await TokenService.getToken();

    final uri = Uri.parse('$baseUrl/auth/logout');

    try {
      await http.patch(uri, headers: {"Authorization": 'Bearer $token'});
      await TokenService.removeToken();
    } catch (error) {
      throw Exception(error);
    }
  }

  static Future<void> savePreferences(
      String userId, List<UserPreference> preferences) async {
    final token = await TokenService.getToken();
    final uri = Uri.parse('$baseUrl/user-preferences');

    final requestPayload = UserPreferencesRequest(
      userId: userId,
      preferences: preferences,
    );

    try {
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(requestPayload.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception(
            'Failed to save preferences. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Exception in ApiService.savePreferences: $error');
    }
  }

  static Future<List<UserPreferenceResponse>> getPreferences(
      String userId) async {
    final token = await TokenService.getToken();
    final uri = Uri.parse('$baseUrl/user-preferences/$userId');

    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to fetch preferences. Status code: ${response.statusCode}');
      }

      final List<dynamic> data = json.decode(response.body);
      return data
          .map<UserPreferenceResponse>((json) =>
              UserPreferenceResponse.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw Exception('Exception in ApiService.getPreferences: $error');
    }
  }

  static List<Note> parseNotes(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Note>((json) => Note.fromJson(json)).toList();
  }

  static Future<List<Note>> getNotes(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/notes/$userId'));

    if (response.statusCode == 200) {
      return parseNotes(response.body);
    } else {
      throw Exception('Failed to load notes');
    }
  }

  static Future<void> addNote(Map<String, dynamic> notePayload) async {
    final token = await TokenService.getToken();
    final uri = Uri.parse('$baseUrl/notes');

    try {
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(notePayload),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to save preferences');
      }
    } catch (error) {
      throw Exception('Exception in ApiService.savePreferences: $error');
    }
  }
}
