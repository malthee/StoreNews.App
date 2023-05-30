import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import 'package:storenews/domain/news_item.dart';
import 'package:storenews/ui/widgets/news_scan_settings_button.dart';
import 'package:storenews/ui/widgets/news_item_list.dart';
import 'package:storenews/ui/widgets/permissions_missing_dialog.dart';
import 'package:storenews/util/constants.dart';
import '../../i18n/news_overview.i18n.dart';
import '../../manager/news_manager.dart';

class NewsOverview extends StatefulWidget with GetItStatefulWidgetMixin {
  final Function(bool) onDarkModeToggle;

  NewsOverview({super.key, required this.onDarkModeToggle});

  @override
  State<NewsOverview> createState() => _NewsOverviewState();
}

class _NewsOverviewState extends State<NewsOverview> with GetItStateMixin {
  final newsManager = GetIt.I<NewsManager>();
  final newsItems = <NewsItem>[];
  late final StreamSubscription<NewsItem> _newsItemSubscription;

  @override
  void initState() {
    super.initState();
    // Show dialog if setup failed
    initPlatformState().then((value) => {
          if (!value)
            showDialog(
                context: context,
                builder: (context) => const PermissionsMissingDialog())
        });

    _newsItemSubscription = _listenToNewsItems();
  }

  StreamSubscription<NewsItem> _listenToNewsItems() {
    return newsManager.fetchedNewsStream.listen((newsItem) {
      setState(() {
        newsItems.insert(0, newsItem);
      });
    });
  }

  Future<bool> initPlatformState() async {
    // Try setup and start the news fetch
    return await newsManager.startNewsFetch();
  }

  @override
  void dispose() {
    _newsItemSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkModeEnabled = Theme.of(context).brightness == Brightness.dark;
    final scanRunning = watchX((NewsManager n) => n.isRunning);

    return Scaffold(
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.all(InsetSizes.small),
            child: Image(image: AssetImage('assets/icon/storenews.png')),
          ),
          title: const Text('Store News'),
          actions: [
            IconButton(
                onPressed: () => widget.onDarkModeToggle(!darkModeEnabled),
                icon: Visibility(
                  visible: darkModeEnabled,
                  replacement: const Icon(Icons.dark_mode),
                  child: const Icon(Icons.light_mode),
                )),
            NewsScanSettingsButton()
          ],
        ),
        body: Column(
          children: [
            _ScanNotRunning(isScanning: scanRunning),
            Expanded(
                child: NewsItemList(newsItems: newsItems, showTimeAgo: true)),
          ],
        ));
  }
}

class _ScanNotRunning extends StatelessWidget {
  final bool isScanning;

  const _ScanNotRunning({super.key, required this.isScanning});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !isScanning,
      child: Container(
        alignment: Alignment.topRight,
        padding: const EdgeInsets.only(right: InsetSizes.medium),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Restart scanning to get the latest news'.i18n),
            const SizedBox(width: InsetSizes.small),
            const Icon(Icons.switch_access_shortcut)
          ],
        ),
      ),
    );
  }
}
