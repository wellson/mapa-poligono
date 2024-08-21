import 'place_type.dart';

base class PlaceEntity {
  const PlaceEntity({
    required this.uuid,
    required this.type,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  final String uuid;
  final PlaceType type;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
}
