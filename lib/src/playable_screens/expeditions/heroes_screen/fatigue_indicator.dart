import 'dart:async';
import 'package:flutter/material.dart';
import 'package:game_template/src/temporary_database/expeditions/models/character.dart';

class FatigueIndicator extends StatelessWidget {
  final Character character;

  const FatigueIndicator({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: Stream.periodic(
        Duration(seconds: 1),
        (_) => character.remainingRestTime,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.inSeconds > 0) {
          double progress = 1.0;
          String timeText = '00:00';

          if (snapshot.hasData) {
            final duration = snapshot.data!;
            progress =
                duration.inSeconds / (1 * 60); // 12 minut = pełna regeneracja
            timeText =
                '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
          }

          return Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 20.0,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
              Text(
                timeText,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
