import 'package:flutter/material.dart';
import 'package:my_crumbl/services/cookie_search_delegate.dart';

import '../pages/home/cookie_detail_page.dart';

class MyCrumblSearchWidget extends StatelessWidget {
  final String uid;
  final int tabIndex;

  const MyCrumblSearchWidget(
      {Key? key, required this.uid, required this.tabIndex})
      : super(key: key);

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
          final displayName = await showSearch(
            context: context,
            delegate: CookieSearchDelegate(uid: uid, tabIndex: tabIndex),
          );
          if (displayName == null) {
            return;
          }

          // await DataRepository(uid: uid)
          //     .fetchCookie(displayName)
          //     .then((cookie) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CookieDetailPage(cookie: displayName),
            ),
          );
          // });
        },
        label: const Text('Search for a cookie by name'),
      ),
    );
  }
}
