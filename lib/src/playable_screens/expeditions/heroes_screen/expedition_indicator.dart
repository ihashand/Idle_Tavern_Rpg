import 'dart:async';
import 'package:flutter/material.dart';
import '../../../temporary_database/expeditions/models/expedition.dart';

class ExpeditionIndicator extends StatelessWidget {
  final Expedition expedition;

  const ExpeditionIndicator({Key? key, required this.expedition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: Stream.periodic(
        Duration(seconds: 1),
        (_) => expedition.remainingRestTime,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.inSeconds > 0) {
          double progress = 1.0;
          String timeText = '00:00';

          if (snapshot.hasData) {
            final duration = snapshot.data!;
            progress = duration.inSeconds / (expedition.duration * 60);
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
