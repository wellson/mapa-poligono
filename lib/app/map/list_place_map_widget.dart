import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/domain/entities/place_entity.dart';
import '../shared/app_asset.dart';

class ListPlaceMapWidget extends StatefulWidget {
  const ListPlaceMapWidget({
    super.key,
    required this.places,
    required this.onShow,
  });

  final List<PlaceEntity> places;
  final void Function(PlaceEntity) onShow;

  @override
  State<ListPlaceMapWidget> createState() => _ListPlaceMapWidgetState();
}

class _ListPlaceMapWidgetState extends State<ListPlaceMapWidget> {
  late List<PlaceEntity> places;
  late void Function(PlaceEntity) onShow;

  void initialize() {
    places = widget.places;
    onShow = widget.onShow;
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void didUpdateWidget(covariant ListPlaceMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget != oldWidget) {
      initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: places.length,
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 30,
        ),
        itemBuilder: (context, index) {
          final placeEntity = places.elementAt(index);
          return Card(
            child: ListTile(
              leading: Image.asset(
                '${AppAsset.images}${placeEntity.type.name}.png',
                width: 48,
                height: 48,
              ),
              title: Text(placeEntity.title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Get.back();
                Get.showSnackbar(
                  const GetSnackBar(
                    message: 'Mostrando local...',
                    duration: Duration(
                      seconds: 1,
                    ),
                    showProgressIndicator: true,
                  ),
                );
                onShow(placeEntity);
              },
            ),
          );
        },
      ),
    );
  }
}
