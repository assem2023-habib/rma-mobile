import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/failures.dart';
import 'package:rma_customer/features/new_parcel/domain/entities/new_parcel.dart';
import 'package:rma_customer/features/new_parcel/domain/repositories/new_parcel_repository.dart';
import 'package:rma_customer/features/new_parcel/data/datasources/new_parcel_remote_datasource.dart';
import 'package:rma_customer/features/new_parcel/data/models/new_parcel_model.dart';

class NewParcelRepositoryImpl implements NewParcelRepository {
  final NewParcelRemoteDataSource remoteDataSource;

  NewParcelRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Unit>> createParcel(NewParcel parcel) async {
    try {
      final model = NewParcelModel.fromEntity(parcel);
      await remoteDataSource.createParcel(model);
      return const Right(unit);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
