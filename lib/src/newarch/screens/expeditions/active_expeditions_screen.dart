import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_template/src/newarch/providers/expedition_provider.dart';

class ActiveExpeditionsScreen extends ConsumerWidget {
  const ActiveExpeditionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tutaj powinna być logika pobierania danych o aktywnych ekspedycjach
    // Na razie używamy danych przykładowych

    final activeExpeditions = ref.watch(activeExpeditionsProvider);

    return ListView.builder(
      itemCount: activeExpeditions.length,
      itemBuilder: (context, index) {
        var expedition = activeExpeditions[index];
        return ListTile(
          title: Text(expedition.name),
          subtitle: LinearProgressIndicator(value: expedition.progress),
        );
      },
    );
  }
}
