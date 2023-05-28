import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_view/photo_view.dart';
import 'package:storenews/domain/news_item.dart';
import 'package:storenews/ui/widgets/news_item_expires_icon.dart';
import 'package:storenews/util/dynamic_datetime_format.dart';
import 'package:storenews/util/navigation_helper.dart';

import '../../service/image_service.dart';
import '../../util/constants.dart';
import '../widgets/store_icon_name.dart';
import '../../i18n/news_detail.i18n.dart';

class NewsDetail extends StatelessWidget {
  final NewsItem newsItem;

  const NewsDetail({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: _AppBarStoreTitle(newsItem: newsItem),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ItemExpired(newsItem: newsItem),
            _DetailTitle(newsItem: newsItem),
            Visibility(
                visible: newsItem.detailImageId != null,
                child: _DetailImageView(
                    key: ValueKey("${newsItem.id}_detailImage"),
                    imageId: newsItem.detailImageId!)),
            Center(
                child: Text('last changed %s'
                    .i18n
                    .fill([formatDateTimeDynamically(newsItem.lastChanged)]))),
            _DetailsText(newsItem: newsItem),
          ],
        ),
      ),
    );
  }
}

class _DetailImageView extends StatelessWidget {
  final String imageId;

  const _DetailImageView({
    super.key,
    required this.imageId,
  });

  @override
  Widget build(BuildContext context) {
    final imageService = GetIt.I<ImageService>();

    return FutureBuilder(
        future: imageService.getImageById(imageId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final imageData = snapshot.data!;
            return PhotoView(
                tightMode: true,
                minScale: PhotoViewComputedScale.contained * 0.5,
                maxScale: PhotoViewComputedScale.contained * 2,
                imageProvider: Image.memory(imageData.data,
                        key: ValueKey("${imageId}_image"))
                    .image);
          } else if (!snapshot.hasError) {
            return const Center(child: CircularProgressIndicator());
          }
          return const SizedBox.shrink();
          // Don't show anything on error or no image
        });
  }
}

class _AppBarStoreTitle extends StatelessWidget {
  const _AppBarStoreTitle({
    super.key,
    required this.newsItem,
  });

  final NewsItem newsItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Clickable navigation to the store
    return Container(
      margin: const EdgeInsets.only(right: InsetSizes.small),
      child: Material(
        borderRadius: BorderRadius.circular(BorderSizes.circularRadius),
        child: InkWell(
          onTap: () => _storeTapped(
              context, newsItem.companyNumber, newsItem.storeNumber),
          borderRadius: BorderRadius.circular(BorderSizes.circularRadius),
          child: Padding(
            padding: const EdgeInsets.all(InsetSizes.small),
            child: StoreIconName(
                companyNumber: newsItem.companyNumber,
                storeNumber: newsItem.storeNumber),
          ),
        ),
      ),
    );
  }

  void _storeTapped(BuildContext context, int companyNumber, int storeNumber) =>
      navigateToStore(context, companyNumber, storeNumber);
}

class _ItemExpired extends StatelessWidget {
  const _ItemExpired({super.key, required this.newsItem});

  final NewsItem newsItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Show either nothing or a warning that the item has expired
    return Visibility(
        visible: newsItem.isExpired(DateTime.now()),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(BorderSizes.circularRadius),
                bottomRight: Radius.circular(BorderSizes.circularRadius)),
            color: theme.colorScheme.errorContainer,
          ),
          padding: const EdgeInsets.all(InsetSizes.medium),
          margin: const EdgeInsets.symmetric(vertical: InsetSizes.small),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded),
              const SizedBox(width: 8.0),
              Flexible(
                child: Text(
                    'This item has expired and is no longer valid!'.i18n,
                    style: theme.textTheme.bodyLarge,
                    maxLines: 2,
                    textAlign: TextAlign.center),
              ),
            ],
          ),
        ));
  }
}

class _DetailTitle extends StatelessWidget {
  const _DetailTitle({
    super.key,
    required this.newsItem,
  });

  final NewsItem newsItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(InsetSizes.small),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(newsItem.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                    overflow: TextOverflow.visible),
              ),
            ),
          ),
          NewsItemExpiredIcon(newsItem: newsItem)
        ],
      ),
    );
  }
}

class _DetailsText extends StatelessWidget {
  const _DetailsText({
    super.key,
    required this.newsItem,
  });

  final NewsItem newsItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(InsetSizes.small),
      child: Card(
          child: Container(
        padding: const EdgeInsets.all(InsetSizes.small),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Details'.i18n,
                style: Theme.of(context).textTheme.headlineMedium),
            Text(newsItem.markupContent),
          ],
        ),
      )),
    );
  }
}
