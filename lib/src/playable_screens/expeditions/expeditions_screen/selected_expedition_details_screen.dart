import 'package:flutter/material.dart';
import 'package:game_template/src/temporary_database/expeditions/models/expedition.dart';

class SelectedExpeditionDetailsScreen extends StatelessWidget {
  final Expedition expedition;

  const SelectedExpeditionDetailsScreen({super.key, required this.expedition});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(expedition.name)),
      body: Column(
        children: [
          ListTile(
            title: Text(expedition.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Category: ${expedition.category.toString().split('.').last}'),
                Text('Skill: ${expedition.description}'),
                Text('Payment: ${expedition.duration}'),
              ],
            ),
            leading: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                      "expedition.iconUrl"), // Use AssetImage for local assets
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
