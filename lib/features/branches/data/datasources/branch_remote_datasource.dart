import '../../../../core/api/api_config.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/branch_model.dart';

abstract class BranchRemoteDataSource {
  Future<List<BranchModel>> getAllBranches();
  Future<BranchModel> createBranch(Map<String, dynamic> branchData);
}

class BranchRemoteDataSourceImpl implements BranchRemoteDataSource {
  final DioClient dioClient;

  BranchRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<BranchModel>> getAllBranches() async {
    try {
      final response = await dioClient.get(ApiConfig.superAdminBranches);
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => BranchModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<BranchModel> createBranch(Map<String, dynamic> branchData) async {
    try {
      final response = await dioClient.post(
        ApiConfig.superAdminBranches,
        data: branchData,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return BranchModel.fromJson(response.data['data']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
