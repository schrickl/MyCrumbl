import 'package:flutter/material.dart';
import 'package:my_crumbl/pages/home/cookie_detail_page.dart';
import 'package:my_crumbl/services/cookie_search_delegate.dart';

class MyCrumblSearchWidget extends StatelessWidget {
  const MyCrumblSearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.search),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
        onPressed: () async {
          final query = await showSearch(
            context: context,
            delegate: CookieSearchDelegate(),
          );
          if (query == null) {
            return;
          }
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CookieDetailPage(cookie: query),
            ),
          );
        },
        label: const Text('Search for a cookie by name'),
      ),
    );
  }
}
