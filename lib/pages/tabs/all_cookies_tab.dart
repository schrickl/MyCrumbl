import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:my_crumbl/pages/home/cookie_row.dart';
import 'package:my_crumbl/shared/my_crumbl_search_widget.dart';
import 'package:provider/provider.dart';

DocumentSnapshot<Object?>? lastDocument;

class AllCookiesTab extends StatefulWidget {
  const AllCookiesTab({Key? key}) : super(key: key);

  @override
  State<AllCookiesTab> createState() => _AllCookiesTabState();
}

class _AllCookiesTabState extends State<AllCookiesTab> {
  final TextEditingController _controller = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  static const _pageSize = 10;
  DocumentSnapshot? _lastDocument;
  late final PagingController<int, CookieModel> _pagingController =
      PagingController(firstPageKey: 0);
  late final UserModel _currentUser;
  late final Stream<List<CookieModel>> _mergedCookiesStream;

  @override
  initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _currentUser = Provider.of<UserModel>(context);
    // _mergedCookiesStream =
    //     DataRepository(uid: _currentUser.uid).mergedCookiesStream();
    // _pagingController.addPageRequestListener((pageKey) {
    //   _fetchPage(pageKey);
    // });
  }

  @override
  dispose() {
    _controller.dispose();
    _pagingController.dispose();

    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    print('fetching page: $pageKey');
    try {
      var query = _firestore.collection('cookies').orderBy('displayName');

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final querySnapshot = await query.limit(_pageSize).get();

      final List<CookieModel> items = [];
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final item = CookieModel.fromJson(data);
        items.add(item);
      }

      final isLastPage = items.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(items);
      } else {
        final nextPageKey = pageKey + items.length;
        _lastDocument = querySnapshot.docs.last;
        _pagingController.appendPage(items, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) =>
      // RefreshIndicator(
      //   onRefresh: () => Future.sync(
      //     () => _pagingController.refresh(),
      //   ),
      //   child:
      Column(
        children: [
          MyCrumblSearchWidget(uid: _currentUser.uid, tabIndex: 0),
          Expanded(
            child: PagedListView.separated(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<CookieModel>(
                itemBuilder: (context, cookie, index) => CookieRow(
                  cookie: cookie,
                ),
                // firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
                //   error: _pagingController.error,
                //   onTryAgain: () => _pagingController.refresh(),
                // ),
                // noItemsFoundIndicatorBuilder: (context) => EmptyListIndicator(),
              ),
              padding: const EdgeInsets.all(16),
              separatorBuilder: (context, index) => const SizedBox(
                height: 16,
              ),
            ),
          ),
        ],
      );
}
//       } else {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Text(
//                   'Oops! Nothing to see here. Try rating or favoriting some cookies!',
//                   style: TextStyle(
//                       color: Theme
//                           .of(context)
//                           .colorScheme
//                           .primary,
//                       fontSize: 24.0,
//                       fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center),
//               Image.asset(
//                 'assets/images/no-cookies.png',
//                 fit: BoxFit.contain,
//               ),
//             ],
//           ),
//         );
//       }
//     } else if (snapshot.hasError) {
//       return const Text('Error');
//     } else {
//       return const Center(child: LoadingPage());
//     }
//   },
// );
//     Scaffold(
//   body: Column(
//     children: [
//       MyCrumblSearchWidget(
//         stream: DataRepository(uid: _currentUser.uid).mergedCookiesStream(),
//       ),
//       Expanded(
//         child: PagedListView.separated(
//           pagingController: _pagingController,
//           builderDelegate: PagedChildBuilderDelegate<CookieModel>(
//               itemBuilder: (context, cookie, index) {
//                 return CookieRow(cookie: cookie);
//               },
//               firstPageErrorIndicatorBuilder: (context) => const Center(
//                     child: Text('Error'),
//                   ),
//               newPageErrorIndicatorBuilder: (context) => const Center(
//                     child: Text('Error'),
//                   ),
//               noItemsFoundIndicatorBuilder: (context) => const Center(
//                     child: Text('No items found'),
//                   )),
//           separatorBuilder: (BuildContext context, int index) {
//             return Divider(
//                 color: Theme.of(context).colorScheme.secondary,
//                 thickness: 2.0);
//           },
//         ),
//       ),
//     ],
//   ),
// );
