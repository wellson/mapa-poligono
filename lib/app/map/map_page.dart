import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/domain/entities/place_entity.dart';
import '../../core/domain/entities/place_type.dart';
import '../../shared/constants.dart';
import '../shared/app_theme.dart';
import 'add_place_map_widget.dart';
import 'detail_place_map_widget.dart';
import 'list_place_map_widget.dart';
import 'map_controller.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    super.key,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapController mapController;
  late GoogleMapController googleMapController;

  void showPlaceList(List<PlaceEntity> places) {
    if (places.isEmpty) {
      Get.showSnackbar(
        const GetSnackBar(
          message: 'Nenhum local encontrado',
          duration: Duration(
            seconds: 1,
          ),
        ),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ListPlaceMapWidget(
          places: places,
          onShow: (placeEntity) async {
            await googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(
                    placeEntity.latitude,
                    placeEntity.longitude,
                  ),
                  zoom: 16,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showPlaceAdd(LatLng position) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AddPlaceMapWidget(
          onAdd: (title, description, type) {
            mapController.savePlace(
              PlaceEntity(
                uuid: const Uuid().v4(),
                type: PlaceType.fromParam(type),
                title: title,
                description: description,
                latitude: position.latitude,
                longitude: position.longitude,
                createdAt: DateTime.now(),
              ),
            );
            mapController.listPlaces(showPlaceDetails);
          },
        );
      },
    );
  }

  void showPlaceDetails(PlaceEntity placeEntity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DetailPlaceMapWidget(
          placeEntity: placeEntity,
          onRemove: (placeUuid) {
            mapController.removePlace(placeUuid);
            mapController.listPlaces(showPlaceDetails);
          },
        );
      },
    );
  }

  void onMapCreated(GoogleMapController controller) async {
    googleMapController = controller;
  }

  void initialize() async {
    mapController = Get.find<MapController>();
    mapController.loadInitialPosition();
    mapController.listPlaces(showPlaceDetails);
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appTitle),
        actions: [
          IconButton(
            onPressed: () => showPlaceList(mapController.places.value ?? []),
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: Obx(
        () {
          if (mapController.initialPosition.value == null || mapController.places.value == null || mapController.markers.value == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            buildingsEnabled: false,
            style: AppTheme.mapStyle,
            initialCameraPosition: mapController.initialPosition.value!,
            markers: mapController.markers.value!,
            onMapCreated: onMapCreated,
            onTap: showPlaceAdd,
          );
        },
      ),
    );
  }
}
