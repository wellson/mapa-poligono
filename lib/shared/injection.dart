import 'package:get/get.dart';
import 'package:logger/web.dart';

import '../app/map/map_controller.dart';
import '../core/application/repositories/place_repository_sqlite.dart';
import '../core/application/usecases/list_place_usecase.dart';
import '../core/application/usecases/remove_place_usecase.dart';
import '../core/application/usecases/save_place_usecase.dart';
import '../core/data/datasource_sqlite.dart';

void initializeInjection() {
  Get.put(
    Logger(),
  );
  Get.put(
    DatasourceSqlite(),
  );
  Get.put(
    PlaceRepositorySqlite(
      Get.find<DatasourceSqlite>(),
    ),
  );
  Get.put(
    ListPlaceUsecase(
      Get.find<PlaceRepositorySqlite>(),
      Get.find<Logger>(),
    ),
  );
  Get.put(
    RemovePlaceUsecase(
      Get.find<PlaceRepositorySqlite>(),
      Get.find<Logger>(),
    ),
  );
  Get.put(
    SavePlaceUsecase(
      Get.find<PlaceRepositorySqlite>(),
      Get.find<Logger>(),
    ),
  );
  Get.put(
    MapController(
      Get.find<ListPlaceUsecase>(),
      Get.find<RemovePlaceUsecase>(),
      Get.find<SavePlaceUsecase>(),
    ),
  );
}
