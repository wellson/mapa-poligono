import '../../domain/entities/place_entity.dart';
import '../../domain/repositories/place_repository.dart';
import '../datasources/datasource.dart';
import '../models/place_model_sqlite.dart';

final class PlaceRepositorySqlite implements PlaceRepository {
  const PlaceRepositorySqlite(
    this._sqliteDatasource,
  );

  final Datasource _sqliteDatasource;

  @override
  Future<void> save(PlaceEntity placeEntity) async {
    await _sqliteDatasource.save(PlaceModelSqlite.fromEntity(placeEntity).toMap());
  }

  @override
  Future<void> remove(String placeUuid) async {
    await _sqliteDatasource.remove('guid', placeUuid);
  }

  @override
  Future<List<PlaceEntity>> list() async {
    final data = await _sqliteDatasource.list();
    return data.map((e) => PlaceModelSqlite.fromMap(e).toEntity()).toList();
  }
}
