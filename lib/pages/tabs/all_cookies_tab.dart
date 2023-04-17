import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/pages/home/cookie_row.dart';
import 'package:my_crumbl/shared/my_crumbl_search_widget.dart';

DocumentSnapshot<Object?>? lastDocument;

class AllCookiesTab extends StatefulWidget {
  const AllCookiesTab({Key? key}) : super(key: key);

  @override
  State<AllCookiesTab> createState() => _AllCookiesTabState();
}

class _AllCookiesTabState extends State<AllCookiesTab> {
  final TextEditingController _controller = TextEditingController();
  final firestore = FirebaseFirestore.instance;
  final collectionRef = FirebaseFirestore.instance.collection('cookies');
  static const _pageSize = 10;
  DocumentSnapshot? _lastDocument;
  final PagingController<int, CookieModel> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  dispose() {
    _controller.dispose();
    _pagingController.dispose();

    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      var query = FirebaseFirestore.instance
          .collection('cookies')
          .orderBy('displayName');

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const MyCrumblSearchWidget(),
          Expanded(
            child: PagedListView.separated(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<CookieModel>(
                  itemBuilder: (context, item, index) {
                final cookie = _pagingController.itemList![index];
                return CookieRow(cookie: cookie);
              }),
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                    color: Theme.of(context).colorScheme.secondary,
                    thickness: 2.0);
              },
            ),
          ),
        ],
      ),
    );
  }
}
