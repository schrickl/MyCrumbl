import 'package:flutter/material.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/services/data_repository.dart';
import 'package:my_crumbl/shared/loading_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CookieSearchDelegate extends SearchDelegate<CookieModel> {
  final String uid;
  final int tabIndex;

  CookieSearchDelegate({required this.uid, required this.tabIndex});

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
          if (query.isEmpty) {
            Navigator.pop(context);
          } else {
            query = '';
            showSuggestions(context);
          }
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
    return FutureBuilder<List<CookieModel>>(
      future: DataRepository(uid: uid).getFutureCookies(query, tabIndex),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: LoadingPage(),
          );
        } else if (snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              ' 😫 No Cookies Found!',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 16.0,
              ),
            ),
          );
        }

        final List<CookieModel>? matches = snapshot.data;
        return ListView.separated(
          itemCount: matches!.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.cookie),
              title: Text(matches[index].displayName),
              onTap: () {
                close(context, matches[index]);
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
                color: Theme.of(context).colorScheme.secondary, thickness: 2.0);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<CookieModel>>(
      future: DataRepository(uid: uid).getFutureCookies(query, tabIndex),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: LoadingPage(),
          );
        } else if (snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              ' 😫 No Cookies Found!',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 16.0,
              ),
            ),
          );
        }

        final List<CookieModel>? matches = snapshot.data;
        return ListView.separated(
          itemCount: matches!.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.cookie),
              title: Text(matches[index].displayName),
              onTap: () {
                query = matches[index].displayName;
                showResults(context);
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
                color: Theme.of(context).colorScheme.secondary, thickness: 2.0);
          },
        );
      },
    );
  }

  Future<void> saveSuggestions(String displayName) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('suggestions', displayName);
  }

  Future<String> getSuggestions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('suggestions') ?? '';
  }
}
