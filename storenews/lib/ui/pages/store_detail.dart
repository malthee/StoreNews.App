import 'package:flutter/material.dart';
import 'package:storenews/ui/widgets/image_loading_carousel.dart';
import 'package:storenews/ui/widgets/news_item_list.dart';

import '../../util/constants.dart';

class StoreDetail extends StatelessWidget {
  final int companyNumber, storeNumber;

  const StoreDetail(
      {super.key, required this.companyNumber, required this.storeNumber});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.all(InsetSizes.small),
              child: Row(
                children: [
                  // TODO load ico from store
                  const Icon(Icons.business_center),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text('Billa Hagenberg, Hauptstraße 16',
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium)),
                ],
              ),
            )),
        body: Column(
          children: [
            //ImageLoadingCarousel(imageUrls: []),
            NewsItemList(newsItems: [])
            // TODO load news
          ],
        ));
  }
}
