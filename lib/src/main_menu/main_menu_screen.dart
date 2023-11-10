// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../games_services/games_services.dart';
import '../settings/settings.dart';
import '../style/responsive_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gamesServicesController = context.watch<GamesServicesController?>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    return ValueListenableBuilder<String>(
      valueListenable: settingsController.playerName,
      builder: (context, playerName, child) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/menu/homescreen.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              ResponsiveScreen(
                mainAreaProminence: 0.45,
                squarishMainArea: Center(
                  child: Transform.rotate(
                    angle: -0.05,
                    child: SizedBox(
                      height: 800,
                      child: Text(
                        playerName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Permanent Marker',
                          fontSize: 40,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                rectangularMenuArea: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _gap,
                    if (gamesServicesController != null) ...[
                      _hideUntilReady(
                        ready: gamesServicesController.signedIn,
                        child: FilledButton(
                          onPressed: () =>
                              gamesServicesController.showAchievements(),
                          child: const Text('Achievements'),
                        ),
                      ),
                      _gap,
                      _hideUntilReady(
                        ready: gamesServicesController.signedIn,
                        child: FilledButton(
                          onPressed: () =>
                              gamesServicesController.showLeaderboard(),
                          child: const Text('Leaderboard'),
                        ),
                      ),
                      _gap,
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // równomierne rozmieszczenie
                      children: [
                        FilledButton(
                          onPressed: () {
                            audioController.playSfx(SfxType.buttonTap);
                            GoRouter.of(context).go('/play');
                          },
                          child: Text('play').tr(),
                        ),
                        Spacer(), // elastyczna przestrzeń między przyciskami
                        ValueListenableBuilder<bool>(
                          valueListenable: settingsController.muted,
                          builder: (context, muted, child) {
                            return IconButton(
                              onPressed: () => settingsController.toggleMuted(),
                              icon: Icon(
                                muted ? Icons.volume_off : Icons.volume_up,
                              ),
                              color: Color.fromARGB(255, 15, 147, 255),
                            );
                          },
                        ),
                        Spacer(), // elastyczna przestrzeń między przyciskami
                        IconButton(
                          onPressed: () =>
                              GoRouter.of(context).push('/settings'),
                          icon: Icon(
                            Icons.settings,
                          ),
                          color: Color.fromARGB(255, 15, 147, 255),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          extendBody: true,
          // This makes bootom bar transparent, that we can use ours
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
          ),
        );
      },
    );
  }

  Widget _hideUntilReady({required Widget child, required Future<bool> ready}) {
    return FutureBuilder<bool>(
      future: ready,
      builder: (context, snapshot) {
        return Visibility(
          visible: snapshot.data ?? false,
          maintainState: true,
          maintainSize: true,
          maintainAnimation: true,
          child: child,
        );
      },
    );
  }

  static const _gap = SizedBox(height: 10);
}
