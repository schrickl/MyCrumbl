import 'package:flutter/material.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:my_crumbl/pages/tabs/all_cookies_tab.dart';
import 'package:my_crumbl/pages/tabs/current_cookies_tab.dart';
import 'package:my_crumbl/pages/tabs/favorite_cookies_tab.dart';
import 'package:my_crumbl/pages/tabs/rated_cookies_tab.dart';
import 'package:my_crumbl/services/data_repository.dart';
import 'package:my_crumbl/shared/loading_page.dart';
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
  late int _defaultIndex;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.index == UserDataModel.defaultViewAll) {
      _defaultIndex = 0;
    } else if (widget.index == UserDataModel.defaultViewFavorites) {
      _defaultIndex = 1;
    } else if (widget.index == UserDataModel.defaultViewRated) {
      _defaultIndex = 2;
    } else if (widget.index == UserDataModel.defaultViewCurrent) {
      _defaultIndex = 3;
    }

    _tabController =
        TabController(length: 4, vsync: this, initialIndex: _defaultIndex);
    _tabController.addListener(() {
      setState(() {
        _defaultIndex = _tabController.index;
      });
    });
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
    Tab(text: 'In Stores')
  ];

  final List<Widget> tabBarViews = [
    const AllCookiesTab(),
    const FavoriteCookiesTab(),
    const RatedCookiesTab(),
    const CurrentCookiesTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final UserModel? currentUser = Provider.of<UserModel>(context);
    final UserDataModel? dataModel = Provider.of<UserDataModel?>(context);

    return DefaultTabController(
      length: tabBarViews.length,
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: Theme
                  .of(context)
                  .colorScheme
                  .primary,
              labelStyle:
              TextStyle(fontSize: MediaQuery
                  .of(context)
                  .size
                  .width / 32),
              tabs: tabs,
              onTap: (index) async {
                setState(() {
                  _isLoading = true;
                });
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
                  case 3:
                    await DataRepository(uid: currentUser!.uid)
                        .updateUserDataModel(dataModel!.copyWith(
                        defaultView: UserDataModel.defaultViewCurrent));
                    break;
                }
                setState(() {
                  _isLoading = false;
                });
              },
            ),
            Expanded(
              child: _isLoading ?
              const LoadingPage() :
              TabBarView(
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
