import 'package:hive/hive.dart';
import 'package:mentecart_mobile/core/utils/logger.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);

  Future<String?> getToken();

  Future<void> deleteToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _tokenKey = 'access_token';
  static const String _boxName = 'auth';

  @override
  Future<void> saveToken(String token) async {
    try {
      final box = Hive.box(_boxName);
      await box.put(_tokenKey, token);
      AppLogger.info('Token saved locally');
    } catch (e) {
      AppLogger.error('Error saving token: $e');
      throw Exception('Failed to save token');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      final box = Hive.box(_boxName);
      final token = box.get(_tokenKey);
      return token as String?;
    } catch (e) {
      AppLogger.error('Error retrieving token: $e');
      return null;
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      final box = Hive.box(_boxName);
      await box.delete(_tokenKey);
      AppLogger.info('Token deleted locally');
    } catch (e) {
      AppLogger.error('Error deleting token: $e');
      throw Exception('Failed to delete token');
    }
  }
}