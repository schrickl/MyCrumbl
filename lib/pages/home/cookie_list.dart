import 'package:flutter/material.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/pages/home/cookie_row.dart';
import 'package:my_crumbl/services/auth_service.dart';
import 'package:my_crumbl/services/firestore_service.dart';
import 'package:my_crumbl/shared/colors.dart';
import 'package:my_crumbl/shared/loading_page.dart';
import 'package:my_crumbl/shared/my_crumbl_text_form_field.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CookieList extends StatefulWidget {
  const CookieList({Key? key}) : super(key: key);

  @override
  State<CookieList> createState() => _CookieListState();
}

class _CookieListState extends State<CookieList> {
  final AuthService _auth = AuthService();
  final FirestoreService _firestore = FirestoreService();
  final _searchBarController = TextEditingController();
  Future<List<CookieModel>> _allCookieList = Future.value([]);
  List<CookieModel> _filteredCookieList = [];

  @override
  void initState() {
    super.initState();
    _allCookieList = _firestore.fetchAllCookies();
    _filteredCookieList = [];
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  void _updateFilteredItems(String value) {
    _allCookieList.then(
      (items) {
        setState(
          () {
            if (value.isEmpty) {
              _filteredCookieList = items;
            } else {
              _filteredCookieList = items
                  .where(
                    (item) => item.displayName.toLowerCase().contains(
                          value.toLowerCase(),
                        ),
                  )
                  .toList();
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CookieModel>>(
      future: _allCookieList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (_filteredCookieList.isEmpty) {
            _filteredCookieList = snapshot.data ?? [];
          }
          return Column(
            children: [
              ToggleSwitch(
                minWidth: MediaQuery.of(context).size.width * 0.8,
                initialLabelIndex: 0,
                totalSwitches: 3,
                labels: const ['Alphabetical', 'Favorites', 'Rating'],
                onToggle: (index) {
                  switch (index) {
                    case 0:
                      _filteredCookieList.sort(
                          (a, b) => a.displayName.compareTo(b.displayName));
                      break;
                    case 1:
                      _filteredCookieList.sort((a, b) {
                        if (a.isFavorite! && !b.isFavorite!) {
                          return -1;
                        } else if (!a.isFavorite! && b.isFavorite!) {
                          return 1;
                        } else {
                          return 0;
                        }
                      });
                      break;
                    case 2:
                      _filteredCookieList
                          .sort((a, b) => a.rating!.compareTo(b.rating!));
                      break;
                  }
                },
              ),
              MyCrumblTextFormField(
                controller: _searchBarController,
                hintText: 'Search for a cookie by name',
                obscureText: false,
                validator: null,
                prefixIcon: const Icon(Icons.search),
                keyboardType: TextInputType.text,
                onChanged: _updateFilteredItems,
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(8.0),
                  separatorBuilder: (context, index) => const Divider(
                      color: CrumblColors.bright1, thickness: 2.0),
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: _filteredCookieList.length,
                  itemBuilder: (context, index) {
                    final cookie = _filteredCookieList[index];
                    return CookieRow(
                      controller: _searchBarController,
                      cookie: cookie,
                    );
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return const LoadingPage();
        }
      },
    );
  }
}
