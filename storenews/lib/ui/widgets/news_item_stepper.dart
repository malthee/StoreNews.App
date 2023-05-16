import 'package:flutter/material.dart';
import 'package:i18n_extension/default.i18n.dart';
import 'package:storenews/domain/news_item.dart';

class NewsItemStepper extends StatelessWidget {
  final List<NewsItem> newsItems;

  const NewsItemStepper({super.key, required this.newsItems});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: newsItems.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
            horizontalTitleGap: 0.0,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            titleAlignment: ListTileTitleAlignment.center,
            onTap: () => _stepTapped(index),
            leading: IconButton(
              icon: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Theme.of(context).colorScheme.surface),
                  child: Icon(Icons.business_center)),
              onPressed: () {},
            ),
            title: Text(newsItems[index].name,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(newsItems[index].markdownContent,
                maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: _newsItemExpiredIcon(index),
          ),
        );
      },
    );
  }

  void _stepTapped(int index) {}

  Widget _newsItemExpiredIcon(int index) {
    final currentTime = DateTime.now();
    final expires = newsItems[index].expires;
    
    if(expires == null) {
      return Tooltip(
        message: 'Never expires'.i18n,
        child: const Icon(Icons.check_circle, color: Colors.green),
      );
    } else if(currentTime.isAfter(expires)) {
      return Tooltip(
        message: 'Expired on %s'.i18n.fill([expires]),
        child: const Icon(Icons.warning_amber, color: Colors.yellow),
      );
    } else {
      return Tooltip(
        message: 'Expires on %s'.i18n.fill([expires]),
        child: const Icon(Icons.check_circle, color: Colors.green),
      );
    }
    
    
  }
}
