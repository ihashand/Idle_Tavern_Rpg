import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class QuestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('quests').tr(),
      ),
      body: Center(
        child: Text('This is the quest Screen'),
      ),
    );
  }
}
