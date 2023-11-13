import 'package:game_template/src/temporary_database/tavern/tavern_data/tavern_upgrade_data.dart';

class BuildingImagePaths {
  final String tavern;
  final String woodStorage;

  BuildingImagePaths(this.tavern, this.woodStorage);
}

BuildingImagePaths getBuildingImagePaths() {
  String basePath = 'assets/images/menu/';
  String placeholder = '$basePath' 'placeholder.png';

  final tavernUpgradeLvl = tavernUpgrades[0].level;
  String tavern = tavernUpgradeLvl > 0
      ? '$basePath' 'tavern_lvl_${(tavernUpgradeLvl ~/ 10) + 1}.png'
      : placeholder;

  final woodStorageLvl = tavernUpgrades[9].level;
  String woodStorage = woodStorageLvl > 0
      ? '$basePath' 'wood_storage_lvl_${(woodStorageLvl ~/ 10) + 1}.png'
      : placeholder;

  return BuildingImagePaths(
    tavern,
    woodStorage,
  );
}
