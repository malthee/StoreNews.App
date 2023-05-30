import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:storenews/domain/store.dart';
import 'package:storenews/manager/news_manager.dart';
import 'package:storenews/ui/widgets/image_loading_carousel.dart';
import 'package:storenews/ui/widgets/news_item_list.dart';
import 'package:storenews/ui/widgets/store_icon_name.dart';

import '../../domain/news_item.dart';
import '../../service/news_service.dart';
import '../../service/store_service.dart';
import '../../util/constants.dart';
import '../../i18n/store_detail.i18n.dart';

class StoreDetail extends StatelessWidget {
  final int companyNumber, storeNumber;

  const StoreDetail(
      {super.key, required this.companyNumber, required this.storeNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.all(InsetSizes.small),
              child: StoreIconName(
                  companyNumber: companyNumber, storeNumber: storeNumber),
            )),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StoreInformation(
                      companyNumber: companyNumber, storeNumber: storeNumber),
                  _StoreNewsList(
                      companyNumber: companyNumber, storeNumber: storeNumber),
                ],
              )),
            ),
          ],
        ));
  }
}

class _StoreInformation extends StatefulWidget {
  final int companyNumber, storeNumber;

  const _StoreInformation(
      {super.key, required this.companyNumber, required this.storeNumber});

  @override
  State<_StoreInformation> createState() => _StoreInformationState();
}

class _StoreInformationState extends State<_StoreInformation> {
  final storeService = GetIt.I<StoreService>();
  late final Future<Store?> storeFuture;

  @override
  void initState() {
    super.initState();
    storeFuture = storeService.get(widget.companyNumber, widget.storeNumber);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storeFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final store = snapshot.data as Store;

            return Column(
              children: [
                if (store.sliderImageIds != null)
                  ImageLoadingCarousel(imageIds: store.sliderImageIds!),
                _DescriptionText(store: store),
              ],
            );
          } else if (snapshot.hasError) {
            return Row(children: [
              const Icon(Icons.error),
              const SizedBox(width: InsetSizes.small),
              Text('Error loading store'.i18n),
            ]);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

class _DescriptionText extends StatelessWidget {
  const _DescriptionText({
    super.key,
    required this.store,
  });

  final Store store;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: InsetSizes.small),
      child: Container(
        padding: const EdgeInsets.all(InsetSizes.small),
        child: Text(store.description, textAlign: TextAlign.center),
      ),
    );
  }
}

class _StoreNewsList extends StatefulWidget {
  final int companyNumber, storeNumber;

  const _StoreNewsList({
    super.key,
    required this.companyNumber,
    required this.storeNumber,
  });

  @override
  State<_StoreNewsList> createState() => _StoreNewsListState();
}

class _StoreNewsListState extends State<_StoreNewsList> {
  final newsService = GetIt.I<NewsService>();
  final newsManager = GetIt.I<NewsManager>();
  late final Future<List<NewsItem>?> newsItemsFuture;

  @override
  void initState() {
    super.initState();
    // Get all seen news items of this store, so we can mark them as seen
    final seenNewsOfThisStore = newsManager.seenNews
        .where((newsItem) =>
            newsItem.companyNumber == widget.companyNumber &&
            newsItem.storeNumber == widget.storeNumber)
        .toSet();
    newsItemsFuture = newsService
        .getAllNews(widget.companyNumber, widget.storeNumber, 0, storeNewsCount)
        .then((newsItems) => {...seenNewsOfThisStore, ...?newsItems}.toList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: InsetSizes.medium,
              left: InsetSizes.medium,
              right: InsetSizes.medium,
              bottom: InsetSizes.small),
          child: Text('Latest news from this store'.i18n,
              textAlign: TextAlign.start, style: theme.textTheme.titleLarge),
        ),
        FutureBuilder(
            future: newsItemsFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return NewsItemList(
                    newsItems: snapshot.data,
                    // Disable scrolling as is handled by SingleChildScrollView
                    scrollPhysics: const NeverScrollableScrollPhysics());
              } else if (snapshot.hasError) {
                return Center(
                    child: Row(
                  children: [
                    const Icon(Icons.error_outline),
                    const SizedBox(width: InsetSizes.small),
                    Text('Error loading news items'.i18n),
                  ],
                ));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ],
    );
  }
}
