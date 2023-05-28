import 'package:storenews/manager/news_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:flutter/material.dart';
import '../../i18n/news_scan_settings_button.i18n.dart';

class NewsScanSettingsButton extends StatelessWidget with GetItMixin {
  final newsManager = GetIt.I<NewsManager>();

  NewsScanSettingsButton({super.key});

  void onScanToggle(bool enabled) async {
    if (!enabled) {
      await newsManager.stopNewsFetch();
    } else {
      await newsManager.startNewsFetch();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool scanRunning = watchX((NewsManager n) => n.isRunning);

    return PopupMenuButton(
        onSelected: onScanToggle,
        tooltip: 'News Scan Settings'.i18n,
        itemBuilder: (context) => <PopupMenuEntry<bool>>[
              if (!scanRunning)
                PopupMenuItem<bool>(
                  value: true,
                  child: Row(
                    children: [
                      const Icon(Icons.restart_alt),
                      const SizedBox(width: 10),
                      Text('Restart Scan'.i18n)
                    ],
                  ),
                )
              else
                PopupMenuItem<bool>(
                    value: false,
                    child: Row(
                      children: [
                        const Icon(Icons.pause),
                        const SizedBox(width: 10),
                        Text('Pause Scan'.i18n)
                      ],
                    )),
            ]);
  }
}
