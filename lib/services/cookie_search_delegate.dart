import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/services/data_repository.dart';
import 'package:my_crumbl/shared/loading_page.dart';

class CookieSearchDelegate extends SearchDelegate<CookieModel> {
  late final UnmodifiableListView<CookieModel> cookies;
  DataRepository dataRepository =
      DataRepository(uid: 'itCa4XJG66QVpPPwdnLshpE0oV63');

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<List<CookieModel>>(
      stream: dataRepository.allCookies,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final results = snapshot.data!
              .where((cookie) => cookie.displayName
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(results[index].displayName),
                onTap: () {
                  query = results[index].displayName;
                  close(context, results[index]);
                },
              );
            },
          );
        } else {
          return const Center(
            child: LoadingPage(),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox.shrink();
  }
}
