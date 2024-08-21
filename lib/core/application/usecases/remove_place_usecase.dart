import 'package:logger/web.dart';

import '../../domain/repositories/place_repository.dart';
import '../../domain/usecase/usecase.dart';
import '../failures/failure.dart';

final class RemovePlaceUsecase implements Usecase<String, void> {
  const RemovePlaceUsecase(
    this._placeRepository,
    this._logger,
  );

  final PlaceRepository _placeRepository;
  final Logger _logger;

  @override
  Future<void> call(String placeUuid) async {
    try {
      await _placeRepository.remove(placeUuid);
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
