import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get backendBaseUrl {
    final url = dotenv.env['BACKEND_BASE_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('BACKEND_BASE_URL not configured');
    }
    return url;
  }

  static String get appName => dotenv.env['APP_NAME'] ?? 'MenteCart';

  static bool get isDebug => dotenv.env['APP_DEBUG'] == 'true';

  static int get apiTimeout {
    try {
      return int.parse(dotenv.env['API_TIMEOUT'] ?? '30');
    } catch (e) {
      return 30;
    }
  }
}