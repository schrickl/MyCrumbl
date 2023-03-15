import 'package:flutter/material.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:my_crumbl/pages/home/cookie_row.dart';
import 'package:my_crumbl/services/data_repository.dart';
import 'package:my_crumbl/shared/colors.dart';
import 'package:my_crumbl/shared/loading_page.dart';
import 'package:provider/provider.dart';

class AllCookiesTab extends StatefulWidget {
  const AllCookiesTab({Key? key}) : super(key: key);

  @override
  State<AllCookiesTab> createState() => _AllCookiesTabState();
}

class _AllCookiesTabState extends State<AllCookiesTab> {
  TextEditingController controller = TextEditingController();
  List<CookieModel> _filteredCookieList = [];

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  List<CookieModel?> _updateFilteredItems(
      String value, List<CookieModel> items) {
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
    return _filteredCookieList;
  }

  @override
  Widget build(BuildContext context) {
    final _currentUser = Provider.of<UserDataModel>(context);

    return Column(
      children: [
        // if (cookies.isNotEmpty)
        //   MyCrumblTextFormField(
        //     controller: controller,
        //     hintText: 'Search for a cookie by name',
        //     obscureText: false,
        //     validator: null,
        //     prefixIcon: const Icon(Icons.search),
        //     keyboardType: TextInputType.text,
        //     onChanged: (value) {
        //       setState(() {
        //         _updateFilteredItems(value, cookies);
        //       });
        //     },
        //   ),
        StreamBuilder<List<CookieModel>>(
          stream: DataRepository(uid: _currentUser.uid).allCookies,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                final cookieCount = snapshot.data!.length;
                return Expanded(
                  child: ListView.separated(
                      padding: const EdgeInsets.all(8.0),
                      separatorBuilder: (context, index) => const Divider(
                          color: CrumblColors.bright1, thickness: 2.0),
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: _filteredCookieList.isNotEmpty
                          ? _filteredCookieList.length
                          : cookieCount,
                      itemBuilder: (context, index) {
                        return CookieRow(
                            controller: controller,
                            cookie: _filteredCookieList.isNotEmpty
                                ? _filteredCookieList[index]
                                : snapshot.data![index]);
                      }),
                );
              } else {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                          'Oops! Nothing to see here. Try rating or favoriting some cookies!',
                          style: TextStyle(
                              color: CrumblColors.bright1,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                      Image.asset(
                        'assets/images/no-cookies.png',
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else {
              return const Center(child: LoadingPage());
            }
          },
        ),
      ],
    );
  }
}