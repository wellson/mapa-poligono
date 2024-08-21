import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/domain/entities/place_entity.dart';
import '../shared/app_asset.dart';

class DetailPlaceMapWidget extends StatefulWidget {
  const DetailPlaceMapWidget({
    super.key,
    required this.placeEntity,
    required this.onRemove,
  });

  final PlaceEntity placeEntity;
  final void Function(String) onRemove;

  @override
  State<DetailPlaceMapWidget> createState() => _DetailPlaceMapWidgetState();
}

class _DetailPlaceMapWidgetState extends State<DetailPlaceMapWidget> {
  late PlaceEntity placeEntity;
  late void Function(String) onRemove;

  void initialize() {
    placeEntity = widget.placeEntity;
    onRemove = widget.onRemove;
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void didUpdateWidget(covariant DetailPlaceMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget != oldWidget) {
      initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 30,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                '${AppAsset.images}${placeEntity.type.name}.png',
                width: 48,
                height: 48,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      placeEntity.title,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      placeEntity.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              Get.back();
              Get.showSnackbar(
                const GetSnackBar(
                  message: 'Removendo local...',
                  duration: Duration(
                    seconds: 1,
                  ),
                  showProgressIndicator: true,
                ),
              );
              onRemove(placeEntity.uuid);
            },
            child: const Text('Remover local'),
          ),
        ],
      ),
    );
  }
}
