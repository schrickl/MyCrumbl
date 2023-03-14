import 'package:flutter/material.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:my_crumbl/pages/home/cookie_list.dart';
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

    return MultiProvider(
      providers: [
        StreamProvider<UserDataModel?>.value(
          value: DataRepository(uid: currentUser!.uid).userDataModel,
          initialData: null,
          catchError: (_, __) => UserDataModel.defaultUser,
        ),
        StreamProvider<List<CookieModel>>.value(
          value: DataRepository(uid: currentUser.uid).cookies,
          initialData: const [],
          catchError: (_, __) => [],
        ),
      ],
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
              onPressed: () async {},
              icon: const Icon(Icons.settings, color: CrumblColors.bright1),
            ),
            IconButton(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: const Icon(Icons.logout, color: CrumblColors.bright1),
            ),
          ],
        ),
        body: Consumer2<UserDataModel?, List<CookieModel>>(
          builder: (BuildContext context, UserDataModel? userData,
              List<CookieModel> data, Widget? child) {
            if (data.isEmpty) {
              //return const Text('No cookies found');
              return const LoadingPage();
            } else {
              return CookieList(index: userData?.defaultView ?? 'all');
            }
          },
        ),
      ),
    );
  }
}
