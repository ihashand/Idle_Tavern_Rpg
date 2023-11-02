// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../games_services/games_services.dart';
import '../settings/settings.dart';
import '../style/responsive_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const MaterialApp(
      title: 'Localizations',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );

    MaterialApp(
      localeResolutionCallback: (
        locale,
        supportedLocales,
      ) {
        return locale;
      },
    );

    final gamesServicesController = context.watch<GamesServicesController?>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/menu/tawerna1.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: ResponsiveScreen(
          mainAreaProminence: 0.45,
          squarishMainArea: Center(
            child: Transform.rotate(
              angle: -0.05,
              child: SizedBox(
                height: 800,
                child: Text(
                  settingsController.playerName.value,
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
              FilledButton(
                onPressed: () {
                  audioController.playSfx(SfxType.buttonTap);
                  GoRouter.of(context).go('/play');
                },
                child: Text(AppLocalizations.of(context)!.play),
              ),
              _gap,
              if (gamesServicesController != null) ...[
                _hideUntilReady(
                  ready: gamesServicesController.signedIn,
                  child: FilledButton(
                    onPressed: () => gamesServicesController.showAchievements(),
                    child: const Text('Achievements'),
                  ),
                ),
                _gap,
                _hideUntilReady(
                  ready: gamesServicesController.signedIn,
                  child: FilledButton(
                    onPressed: () => gamesServicesController.showLeaderboard(),
                    child: const Text('Leaderboard'),
                  ),
                ),
                _gap,
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(width: 1), // Odstęp między przyciskami
                  ValueListenableBuilder<bool>(
                    valueListenable: settingsController.muted,
                    builder: (context, muted, child) {
                      return IconButton(
                        onPressed: () => settingsController.toggleMuted(),
                        icon: Icon(muted ? Icons.volume_off : Icons.volume_up),
                        color: Color.fromARGB(255, 6, 27, 44),
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () => GoRouter.of(context).push('/settings'),
                    icon: Icon(
                      Icons.settings,
                      color: Color.fromARGB(255, 6, 27, 44),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Prevents the game from showing game-services-related menu items
  /// until we're sure the player is signed in.
  ///
  /// This normally happens immediately after game start, so players will not
  /// see any flash. The exception is folks who decline to use Game Center
  /// or Google Play Game Services, or who haven't yet set it up.
  Widget _hideUntilReady({required Widget child, required Future<bool> ready}) {
    return FutureBuilder<bool>(
      future: ready,
      builder: (context, snapshot) {
        // Use Visibility here so that we have the space for the buttons
        // ready.
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
