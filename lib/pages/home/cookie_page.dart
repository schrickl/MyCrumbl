import 'package:flutter/material.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:my_crumbl/pages/home/cookie_list.dart';
import 'package:my_crumbl/pages/info_page.dart';
import 'package:my_crumbl/services/auth_service.dart';
import 'package:my_crumbl/services/data_repository.dart';
import 'package:my_crumbl/shared/colors.dart';
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
        backgroundColor: CrumblColors.secondary,
        appBar: AppBar(
          backgroundColor: CrumblColors.accentColor,
          centerTitle: true,
          elevation: 0.0,
          title: const Text(
            'MyCrumbl',
            style: TextStyle(
                color: CrumblColors.bright1,
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
              icon: const Icon(Icons.info_outline_rounded,
                  color: CrumblColors.bright1),
            ),
            IconButton(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: const Icon(Icons.logout, color: CrumblColors.bright1),
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
