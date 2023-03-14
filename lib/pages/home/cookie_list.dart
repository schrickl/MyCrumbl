import 'package:flutter/material.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:my_crumbl/pages/tabs/all_cookies_tab.dart';
import 'package:my_crumbl/pages/tabs/favorite_cookies_tab.dart';
import 'package:my_crumbl/pages/tabs/rated_cookies_tab.dart';
import 'package:my_crumbl/services/data_repository.dart';
import 'package:my_crumbl/shared/colors.dart';
import 'package:provider/provider.dart';

class CookieList extends StatefulWidget {
  final String index;

  const CookieList({super.key, required this.index});

  @override
  State<CookieList> createState() => _CookieListState();
}

class _CookieListState extends State<CookieList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int defaultIndex;

  @override
  void initState() {
    super.initState();
    if (widget.index == UserDataModel.defaultViewAll) {
      defaultIndex = 0;
    } else if (widget.index == UserDataModel.defaultViewFavorites) {
      defaultIndex = 1;
    } else if (widget.index == UserDataModel.defaultViewRated) {
      defaultIndex = 2;
    }
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: defaultIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Widget> tabs = const [
    Tab(text: 'All'),
    Tab(text: 'Favorites'),
    Tab(text: 'Rated'),
  ];

  final List<Widget> tabBarViews = [
    AllCookiesTab(),
    const FavoriteCookiesTab(),
    const RatedCookiesTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final UserModel? currentUser = Provider.of<UserModel>(context);
    final UserDataModel? dataModel = Provider.of<UserDataModel?>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: CrumblColors.bright1,
              tabs: tabs,
              onTap: (index) async {
                print('Tab $index changed!');
                switch (index) {
                  case 0:
                    await DataRepository(uid: currentUser!.uid)
                        .updateUserDataModel(dataModel!.copyWith(
                            defaultView: UserDataModel.defaultViewAll));
                    break;
                  case 1:
                    await DataRepository(uid: currentUser!.uid)
                        .updateUserDataModel(dataModel!.copyWith(
                            defaultView: UserDataModel.defaultViewFavorites));
                    break;
                  case 2:
                    await DataRepository(uid: currentUser!.uid)
                        .updateUserDataModel(dataModel!.copyWith(
                            defaultView: UserDataModel.defaultViewRated));
                    break;
                }
              },
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: tabBarViews,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
