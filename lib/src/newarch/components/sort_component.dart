import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sortProvider = StateProvider<String>((ref) => '');

class SortComponent extends ConsumerWidget {
  final List<String> sortOptions;
  final void Function(String) onSortChanged;

  SortComponent(
      {Key? key, required this.sortOptions, required this.onSortChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String currentSort = ref.watch(sortProvider);

    return DropdownButton<String>(
      value: currentSort.isEmpty ? null : currentSort,
      items: sortOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          ref.read(sortProvider.notifier).state = newValue;
          onSortChanged(newValue);
        }
      },
      hint: Text('Wybierz sortowanie'),
    );
  }
}
