import '../../../../core/core_export.dart';
import '../models/car_plate_model.dart';

abstract class CarPlateRemoteDataSource {
  Future<ApiResponse<List<CarPlateModel>>> getCarPlates();
  Future<ApiResponse<CarPlateModel>> addCarPlate(Map<String, dynamic> data);
  Future<ApiResponse<void>> deleteCarPlate(String id);
}

class CarPlateRemoteDataSourceImpl implements CarPlateRemoteDataSource {
  final ApiService _apiService;

  CarPlateRemoteDataSourceImpl(this._apiService);

  @override
  Future<ApiResponse<List<CarPlateModel>>> getCarPlates() async {
    return await _apiService.get<List<CarPlateModel>>(
      ApiEndpoints.carPlates,
      fromJson: (json) {
        final data = json['data'] as List;
        return data
            .map((e) => CarPlateModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<ApiResponse<CarPlateModel>> addCarPlate(Map<String, dynamic> data) async {
    return await _apiService.post<CarPlateModel>(
      ApiEndpoints.carPlates,
      data: data,
      fromJson: (json) => CarPlateModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<void>> deleteCarPlate(String id) async {
    return await _apiService.delete<void>(
      ApiEndpoints.deleteCarPlate(id),
    );
  }
}
