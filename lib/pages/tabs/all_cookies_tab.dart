import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:my_crumbl/pages/home/cookie_row.dart';
import 'package:my_crumbl/services/data_repository.dart';
import 'package:my_crumbl/services/hive_service.dart';
import 'package:my_crumbl/shared/my_crumbl_text_form_field.dart';
import 'package:provider/provider.dart';

class AllCookiesTab extends StatefulWidget {
  const AllCookiesTab({Key? key}) : super(key: key);

  @override
  State<AllCookiesTab> createState() => _AllCookiesTabState();
}

class _AllCookiesTabState extends State<AllCookiesTab> {
  final TextEditingController _controller = TextEditingController();
  List<CookieModel> _filteredCookies = [];
  final firestore = FirebaseFirestore.instance;
  final collectionRef = FirebaseFirestore.instance.collection('cookies');

  @override
  initState() {
    super.initState();

    // final cookies = HiveService.getItems();
    // if (cookies.isNotEmpty) {
    //   setState(() {
    //     _filteredCookies = cookies;
    //   });
    // }
    // Create a query that gets all dog documents
    final query = collectionRef.orderBy(FieldPath.documentId);
    final _dataRepository =
        DataRepository(uid: FirebaseAuth.instance.currentUser!.uid);

    // Set up a real-time listener for the query snapshot
    query.snapshots().listen((querySnapshot) {
      for (final docChange in querySnapshot.docChanges) {
        final docSnapshot = docChange.doc;
        final docId = docSnapshot.id;

        if (docChange.type == DocumentChangeType.modified) {
          if (docSnapshot.data()!.containsKey('isCurrent') ||
              docSnapshot.data()!.containsKey('lastSeen')) {
            _dataRepository.syncMyCookiesWithAllCookies(docId);
          }
        }
      }
    });
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<CookieModel> _getFilteredCookies() {
    final cookies = HiveService.getItems();

    final searchQuery = _controller.text.toLowerCase();
    if (searchQuery.isEmpty) {
      return cookies;
    }

    return cookies
        .where(
            (cookie) => cookie.displayName.toLowerCase().contains(searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final _currentUser = Provider.of<UserModel>(context);
    // final cookies = HiveService.getItems();

    _filteredCookies = _getFilteredCookies();

    return Column(
      children: [
        MyCrumblTextFormField(
          controller: _controller,
          hintText: 'Search for a cookie by name',
          obscureText: false,
          validator: null,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              setState(() {});
            },
          ),
          keyboardType: TextInputType.text,
          onChanged: (value) {
            setState(() {});
          },
        ),
        if (_filteredCookies.isEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'No cookies match the search criteria.',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          Expanded(
            child: SingleChildScrollView(
              child: ListView.separated(
                //key: Key(cookies.length.toString()),
                padding: const EdgeInsets.all(8.0),
                separatorBuilder: (context, index) => Divider(
                    color: Theme.of(context).colorScheme.secondary,
                    thickness: 2.0),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: _filteredCookies.length,
                itemBuilder: (context, index) {
                  final cookie = _filteredCookies[index];
                  return CookieRow(cookie: cookie);
                },
              ),
            ),
          ),
      ],
    );
  }
}
