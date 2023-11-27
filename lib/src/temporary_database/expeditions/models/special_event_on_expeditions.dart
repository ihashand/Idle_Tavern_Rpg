import 'dart:math';

import 'character.dart';

class SpecialEventOnExpeditions {
  String description;
  Function onSuccess;
  Function onFailure;

  SpecialEventOnExpeditions(this.description, this.onSuccess, this.onFailure);

  Map<String, dynamic> executeEvent(Character character) {
    bool isSuccess = Random().nextDouble() > 0.5; // 50% szans na sukces
    if (isSuccess) {
      return {"success": true, "effect": onSuccess(character)};
    } else {
      return {"success": false, "effect": onFailure(character)};
    }
  }
}
