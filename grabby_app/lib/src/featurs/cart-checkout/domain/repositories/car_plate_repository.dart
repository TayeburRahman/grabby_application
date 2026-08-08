import '../../../../core/core_export.dart';
import '../../data/models/car_plate_model.dart';

abstract class CarPlateRepository {
  Future<ApiResponse<List<CarPlateModel>>> getCarPlates();
  Future<ApiResponse<CarPlateModel>> addCarPlate(Map<String, dynamic> data);
  Future<ApiResponse<void>> deleteCarPlate(String id);
}
