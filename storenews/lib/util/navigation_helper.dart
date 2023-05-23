import 'package:flutter/material.dart';

import '../domain/news_item.dart';
import '../ui/pages/news_detail.dart';
import '../ui/pages/store_detail.dart';

void navigateToStore(
        BuildContext context, int companyNumber, int storeNumber) =>
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => StoreDetail(
                key: ValueKey('$companyNumber.${storeNumber}_store_detail'),
                storeNumber: storeNumber,
                companyNumber: companyNumber)),
        (route) => route
            .isFirst); // Pop all routes until the first one to avoid looping navigation

void navigateToNewsDetail(BuildContext context, NewsItem newsItem) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => NewsDetail(
          key: ValueKey('$newsItem.id_detail'), newsItem: newsItem)));
}
