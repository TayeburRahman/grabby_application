import '../../../../core/core_export.dart';
import '../../data/datasources/car_plate_remote_data_source.dart';
import '../../data/models/car_plate_model.dart';
import '../../domain/repositories/car_plate_repository.dart';

class CarPlateRepositoryImpl implements CarPlateRepository {
  final CarPlateRemoteDataSource remoteDataSource;

  CarPlateRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResponse<List<CarPlateModel>>> getCarPlates() {
    return remoteDataSource.getCarPlates();
  }

  @override
  Future<ApiResponse<CarPlateModel>> addCarPlate(Map<String, dynamic> data) {
    return remoteDataSource.addCarPlate(data);
  }

  @override
  Future<ApiResponse<void>> deleteCarPlate(String id) {
    return remoteDataSource.deleteCarPlate(id);
  }
}
