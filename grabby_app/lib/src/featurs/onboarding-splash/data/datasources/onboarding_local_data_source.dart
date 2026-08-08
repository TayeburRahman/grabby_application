import '../../../../src_export.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingLocalDataSource {
  Future<void> saveUserRole(UserRole role);
  UserRole? getUserRole();
  bool isFirstTime();
  Future<void> setFirstTime(bool value);
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String kUserRoleKey = 'CACHED_USER_ROLE';
  static const String kIsFirstTimeKey = 'IS_FIRST_TIME';

  OnboardingLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveUserRole(UserRole role) async {
    await sharedPreferences.setString(kUserRoleKey, role.name);
  }

  @override
  UserRole? getUserRole() {
    final roleName = sharedPreferences.getString(kUserRoleKey);
    if (roleName != null) {
      return UserRole.values.firstWhere(
        (role) => role.name == roleName,
        orElse: () => UserRole.customer,
      );
    }
    return null;
  }

  @override
  bool isFirstTime() {
    return sharedPreferences.getBool(kIsFirstTimeKey) ?? true;
  }

  @override
  Future<void> setFirstTime(bool value) async {
    await sharedPreferences.setBool(kIsFirstTimeKey, value);
  }
}
