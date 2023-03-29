import 'package:flutter/material.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:my_crumbl/pages/home/cookie_list.dart';
import 'package:my_crumbl/pages/info_page.dart';
import 'package:my_crumbl/services/auth_service.dart';
import 'package:my_crumbl/services/data_repository.dart';
import 'package:my_crumbl/shared/loading_page.dart';
import 'package:provider/provider.dart';

class CookiePage extends StatefulWidget {
  const CookiePage({super.key});

  @override
  State<CookiePage> createState() => _CookiePageState();
}

class _CookiePageState extends State<CookiePage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final UserModel? currentUser = Provider.of<UserModel>(context);

    return StreamProvider<UserDataModel?>.value(
      value: DataRepository(uid: currentUser!.uid).userDataModel,
      initialData: null,
      catchError: (_, __) => UserDataModel.defaultUser,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            'MyCrumbl',
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 30),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const InfoPage(),
                  ),
                );
              },
              icon: Icon(Icons.info_outline_rounded,
                  color: Theme.of(context).colorScheme.primary),
            ),
            IconButton(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.logout,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
        body: Consumer<UserDataModel?>(
          builder:
              (BuildContext context, UserDataModel? userData, Widget? child) {
            if (userData == null) {
              return const Center(
                child: LoadingPage(),
              );
            }
            return CookieList(index: userData.defaultView ?? 'all');
          },
        ),
      ),
    );
  }
}
