import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class CommonRepository {
  Future<Either<Failure, List<dynamic>>> getCountries();
  Future<Either<Failure, List<dynamic>>> getCities(int countryId);
  Future<Either<Failure, List<dynamic>>> getBranches({int? cityId});
  Future<Either<Failure, dynamic>> getBranchDetail(int branchId);
  Future<Either<Failure, dynamic>> getPricingPolicy();
  Future<Either<Failure, dynamic>> getGeneralInfo();
  Future<Either<Failure, dynamic>> getPrivacyPolicy();
  Future<Either<Failure, dynamic>> getTermsConditions();
  Future<Either<Failure, dynamic>> getAboutUs();
  Future<Either<Failure, List<dynamic>>> getFaqs();
  Future<Either<Failure, void>> contactUs({
    required String name,
    required String email,
    required String phone,
    required String subject,
    required String message,
  });
}
