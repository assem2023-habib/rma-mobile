import '../../../../core/api/api_config.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/employee_model.dart';

abstract class EmployeeRemoteDataSource {
  Future<List<EmployeeModel>> getAllEmployees();
  Future<EmployeeModel> assignEmployee(int userId, int branchId);
}

class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  final DioClient dioClient;

  EmployeeRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<EmployeeModel>> getAllEmployees() async {
    try {
      final response = await dioClient.get(ApiConfig.superAdminEmployees);
      if (response.statusCode == 200) {
        final List data = response.data['data']['employees'];
        return data.map((json) => EmployeeModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<EmployeeModel> assignEmployee(int userId, int branchId) async {
    try {
      final response = await dioClient.post(
        ApiConfig.superAdminAssignEmployee,
        data: {
          'user_id': userId,
          'branch_id': branchId,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return EmployeeModel.fromJson(response.data['data']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
