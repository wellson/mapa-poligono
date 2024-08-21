import '../entities/place_entity.dart';

abstract interface class PlaceRepository {
  Future<void> save(PlaceEntity placeEntity);
  Future<void> remove(String placeUuid);
  Future<List<PlaceEntity>> list();
}
