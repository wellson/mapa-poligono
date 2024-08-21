import '../../domain/entities/place_entity.dart';
import '../../domain/entities/place_type.dart';

final class PlaceModelSqlite extends PlaceEntity {
  const PlaceModelSqlite({
    required super.uuid,
    required super.type,
    required super.title,
    required super.description,
    required super.latitude,
    required super.longitude,
    required super.createdAt,
  });

  factory PlaceModelSqlite.fromEntity(PlaceEntity placeEntity) {
    return PlaceModelSqlite(
      uuid: placeEntity.uuid,
      type: placeEntity.type,
      title: placeEntity.title,
      description: placeEntity.description,
      latitude: placeEntity.latitude,
      longitude: placeEntity.longitude,
      createdAt: placeEntity.createdAt,
    );
  }

  factory PlaceModelSqlite.fromMap(Map<String, dynamic> map) {
    return PlaceModelSqlite(
      uuid: map['guid'] ?? '',
      type: PlaceType.fromParam(map['tipo'] ?? ''),
      title: map['titulo'] ?? '',
      description: map['descricao'] ?? '',
      latitude: map['lat'] ?? 0.0,
      longitude: map['long'] ?? 0.0,
      createdAt: DateTime.parse(map['criadoEm'] ?? DateTime.now().toIso8601String()),
    );
  }

  PlaceEntity toEntity() {
    return PlaceEntity(
      uuid: uuid,
      type: type,
      title: title,
      description: description,
      latitude: latitude,
      longitude: longitude,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'guid': uuid,
      'tipo': type.param,
      'titulo': title,
      'descricao': description,
      'lat': latitude,
      'long': longitude,
      'criadoEm': createdAt.toIso8601String(),
    };
  }
}
