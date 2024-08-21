import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../core/application/failures/failure.dart';
import '../../core/application/usecases/list_place_usecase.dart';
import '../../core/application/usecases/remove_place_usecase.dart';
import '../../core/application/usecases/save_place_usecase.dart';
import '../../core/domain/entities/place_entity.dart';
import '../shared/app_asset.dart';

final class MapController extends GetxController {
  MapController(
    this._listPlaceUsecase,
    this._removePlaceUsecase,
    this._savePlaceUsecase,
  );

  final ListPlaceUsecase _listPlaceUsecase;
  final RemovePlaceUsecase _removePlaceUsecase;
  final SavePlaceUsecase _savePlaceUsecase;

  Rx<CameraPosition?> initialPosition = Rx(null);
  Rx<List<PlaceEntity>?> places = Rx(null);
  Rx<Set<Marker>?> markers = Rx(null);

  Future<LocationData> _getLocation() async {
    final locationLib = Location();
    bool locationEnabled = false;
    locationEnabled = await locationLib.serviceEnabled();
    if (!locationEnabled) {
      locationEnabled = await locationLib.requestService();
      if (!locationEnabled) {
        Get.showSnackbar(const GetSnackBar(message: 'O serviço de localização está desativado.'));
      }
    }
    PermissionStatus hasPermission = PermissionStatus.denied;
    hasPermission = await locationLib.hasPermission();
    if (hasPermission == PermissionStatus.denied) {
      hasPermission = await locationLib.requestPermission();
      if (hasPermission != PermissionStatus.granted) {
        Get.showSnackbar(const GetSnackBar(message: 'A permissão de localização está desativada.'));
      }
    }
    return await locationLib.getLocation();
  }

  void loadInitialPosition() async {
    try {
      final location = await _getLocation();
      initialPosition.value = CameraPosition(
        target: LatLng(
          location.latitude ?? 0.0,
          location.longitude ?? 0.0,
        ),
        zoom: 16,
      );
    } on Failure catch (e) {
      if (e.type.isMessage) {
        Get.showSnackbar(GetSnackBar(message: e.message));
      }
    }
  }

  void listPlaces(void Function(PlaceEntity placeEntity) onTapMarker) async {
    try {
      final resultPlaces = await _listPlaceUsecase.call(null);
      final resultMarkers = await Future.wait(resultPlaces.map(
        (e) async {
          final icon = await BitmapDescriptor.asset(
            const ImageConfiguration(
              size: Size(32, 32),
            ),
            '${AppAsset.images}${e.type.name}.png',
          );
          return Marker(
            onTap: () => onTapMarker(e),
            markerId: MarkerId(
              e.uuid,
            ),
            position: LatLng(
              e.latitude,
              e.longitude,
            ),
            icon: icon,
          );
        },
      ).toList());
      places.value = resultPlaces;
      markers.value = resultMarkers.toSet();
    } on Failure catch (e) {
      if (e.type.isMessage) {
        Get.showSnackbar(GetSnackBar(message: e.message));
      }
    }
  }

  void removePlace(String placeUuid) async {
    if (places.value != null) {
      try {
        await _removePlaceUsecase.call(placeUuid);
        var changedPlaces = places.value!;
        changedPlaces.removeWhere((e) => e.uuid == placeUuid);
        places.value = changedPlaces;
      } on Failure catch (e) {
        if (e.type.isMessage) {
          Get.showSnackbar(GetSnackBar(message: e.message));
        }
      }
    }
  }

  void savePlace(PlaceEntity placeEntity) async {
    if (places.value != null) {
      try {
        await _savePlaceUsecase.call(placeEntity);
        places.value = [...places.value!, placeEntity];
      } on Failure catch (e) {
        if (e.type.isMessage) {
          Get.showSnackbar(GetSnackBar(message: e.message));
        }
      }
    }
  }
}
