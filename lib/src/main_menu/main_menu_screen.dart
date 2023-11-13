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
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();
    final screenHeight = settingsController.getScreenHeight(context);
    final screenWidth = settingsController.getScreenWidth(context);
    final squarishMainAreaHeight = settingsController.getScreenHeight(context);

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(screenHeight, screenWidth, squarishMainAreaHeight,
              settingsController, audioController, context),
          // Tavern
          InteractivePositionedElement(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            context: context,
            assetPath: 'assets/images/menu/karczma.png',
            routePath: '/interior',
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(
      double screenHeight,
      double screenWidth,
      double squarishMainAreaHeight,
      SettingsController settingsController,
      AudioController audioController,
      BuildContext context) {
    final gamesServicesController = context.watch<GamesServicesController?>();

    return Container(
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
            _gap(),
            if (gamesServicesController != null) ...[
              _hideUntilReady(
                ready: gamesServicesController.signedIn,
                child: FilledButton(
                  onPressed: () => gamesServicesController.showAchievements(),
                  child: const Text('Achievements'),
                ),
              ),
              _gap(),
              _hideUntilReady(
                ready: gamesServicesController.signedIn,
                child: FilledButton(
                  onPressed: () => gamesServicesController.showLeaderboard(),
                  child: const Text('Leaderboard'),
                ),
              ),
              _gap(),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(width: screenWidth * 0.01),
                _buildMuteButton(settingsController),
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
    );
  }

  Widget _hideUntilReady({required Future<bool> ready, required Widget child}) {
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

  Widget _buildMuteButton(SettingsController settingsController) {
    return ValueListenableBuilder<bool>(
      valueListenable: settingsController.muted,
      builder: (context, muted, child) {
        return IconButton(
          onPressed: () => settingsController.toggleMuted(),
          icon: Icon(
            muted ? Icons.volume_off : Icons.volume_up,
          ),
          color: Color.fromARGB(255, 6, 27, 44),
        );
      },
    );
  }

  Widget _gap() {
    return SizedBox(height: 10);
  }
}

class InteractivePositionedElement extends StatelessWidget {
  const InteractivePositionedElement({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.context,
    required this.assetPath,
    required this.routePath,
  });

  final double screenHeight;
  final double screenWidth;
  final BuildContext context;
  final String assetPath;
  final String routePath;

  @override
  Widget build(BuildContext context) {
    double topOffset = screenHeight * 0.06;
    double rightOffset = screenWidth * 0.01;

    return Positioned(
      top: topOffset,
      right: rightOffset,
      width: 220, // size of displayed object
      child: InkWell(
        onTap: () {
          GoRouter.of(context).push(routePath);
        },
        child: Image(
          image: AssetImage(assetPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
