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
  const MainMenuScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final gamesServicesController = context.watch<GamesServicesController?>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final squarishMainAreaHeight = screenHeight * 0.5;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/menu/tawerna.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: ResponsiveScreen(
              mainAreaProminence: 0.45,
              squarishMainArea: Center(
                child: Transform.rotate(
                  angle: -0.05,
                  child: SizedBox(
                    height: squarishMainAreaHeight,
                    child: Text(
                      settingsController.playerName.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Permanent Marker',
                        fontSize: screenWidth * 0.05,
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
                    child: Text('play').tr(),
                  ),
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(width: screenWidth * 0.01),
                      ValueListenableBuilder<bool>(
                        valueListenable: settingsController.muted,
                        builder: (context, muted, child) {
                          return IconButton(
                            onPressed: () => settingsController.toggleMuted(),
                            icon: Icon(
                                muted ? Icons.volume_off : Icons.volume_up),
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
          Positioned(
            top: -screenHeight * 0.03,
            right: screenWidth * 0.03,
            child: GestureDetector(
              onTap: () {
                GoRouter.of(context).push('/interior');
              },
              child: Container(
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.all(0),
                width: screenWidth * 0.6,
                height: screenHeight * 0.6,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/menu/karczma.png'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
