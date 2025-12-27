import '../../../../core/api/api_config.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/error/exceptions.dart';

abstract class CommonRemoteDataSource {
  Future<List<dynamic>> getCountries();
  Future<List<dynamic>> getCities(int countryId);
  Future<List<dynamic>> getBranches({int? cityId});
  Future<dynamic> getBranchDetail(int branchId);
  Future<dynamic> getPricingPolicy();
  Future<dynamic> getGeneralInfo();
  Future<dynamic> getPrivacyPolicy();
  Future<dynamic> getTermsConditions();
  Future<dynamic> getAboutUs();
  Future<List<dynamic>> getFaqs();
  Future<void> contactUs({
    required String name,
    required String email,
    required String phone,
    required String subject,
    required String message,
  });
}

class CommonRemoteDataSourceImpl implements CommonRemoteDataSource {
  final DioClient dioClient;

  CommonRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<dynamic>> getCountries() async {
    try {
      final response = await dioClient.get(ApiConfig.countries);
      if (response.statusCode == 200) {
        return response.data['data']['countries'];
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<dynamic>> getCities(int countryId) async {
    try {
      final response = await dioClient.get(
        '${ApiConfig.countries}/$countryId/cities',
      );
      if (response.statusCode == 200) {
        return response.data['data']['cities'];
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<dynamic>> getBranches({int? cityId}) async {
    try {
      final url = cityId != null
          ? '${ApiConfig.branches}/$cityId'
          : ApiConfig.branches;
      final response = await dioClient.get(url);
      if (response.statusCode == 200) {
        return response.data['data']['branches'];
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<dynamic> getBranchDetail(int branchId) async {
    try {
      final response = await dioClient.get(
        '${ApiConfig.branches}/$branchId/detail',
      );
      if (response.statusCode == 200) {
        return response.data['data']['branch'];
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<dynamic> getPricingPolicy() async {
    try {
      final response = await dioClient.get(ApiConfig.pricingPolicy);
      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<dynamic> getGeneralInfo() async {
    try {
      final response = await dioClient.get(ApiConfig.general);
      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<dynamic> getPrivacyPolicy() async {
    try {
      final response = await dioClient.get(ApiConfig.privacyPolicy);
      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<dynamic> getTermsConditions() async {
    try {
      final response = await dioClient.get(ApiConfig.termsConditions);
      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<dynamic> getAboutUs() async {
    try {
      final response = await dioClient.get(ApiConfig.aboutUs);
      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<dynamic>> getFaqs() async {
    try {
      final response = await dioClient.get(ApiConfig.faq);
      if (response.statusCode == 200) {
        return response.data['data']['faqs'];
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> contactUs({
    required String name,
    required String email,
    required String phone,
    required String subject,
    required String message,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConfig.contactUs,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'subject': subject,
          'message': message,
        },
      );
      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
