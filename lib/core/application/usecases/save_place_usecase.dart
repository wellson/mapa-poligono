import 'package:logger/web.dart';

import '../../domain/entities/place_entity.dart';
import '../../domain/repositories/place_repository.dart';
import '../../domain/usecase/usecase.dart';
import '../failures/failure.dart';

final class SavePlaceUsecase implements Usecase<PlaceEntity, void> {
  const SavePlaceUsecase(
    this._placeRepository,
    this._logger,
  );

  final PlaceRepository _placeRepository;
  final Logger _logger;

  @override
  Future<void> call(PlaceEntity input) async {
    try {
      await _placeRepository.save(input);
    } on Failure catch (e, s) {
      if (e.type.isLog) {
        _logger.d(
          e.message,
          stackTrace: s,
        );
      }
      rethrow;
    }
  }
}
