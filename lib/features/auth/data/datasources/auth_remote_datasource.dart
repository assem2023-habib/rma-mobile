import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password, String phoneNumber);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    // Simulated API call
    await Future.delayed(const Duration(seconds: 1));
    return const UserModel(
      id: '1',
      name: 'User Name',
      email: 'user@example.com',
      phoneNumber: '0900000000',
    );
  }

  @override
  Future<UserModel> register(String name, String email, String password, String phoneNumber) async {
    // Simulated API call
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: '2',
      name: name,
      email: email,
      phoneNumber: phoneNumber,
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<UserModel> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const UserModel(
      id: '1',
      name: 'User Name',
      email: 'user@example.com',
      phoneNumber: '0900000000',
    );
  }
}
