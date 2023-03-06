import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/models/user_model.dart';
import 'package:my_crumbl/pages/home/cookie_detail_page.dart';
import 'package:my_crumbl/services/auth_service.dart';
import 'package:my_crumbl/services/firestore_service.dart';
import 'package:my_crumbl/shared/colors.dart';
import 'package:provider/provider.dart';

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
    //_allCookieList = _firestore.fetchAllCookies();
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
    final cookies = Provider.of<UserModel>(context);

    // print all cookies and check for null first
    // cookies.cookies?.forEach((element) {
    //   print(element.displayName);
    // });

    return Container();
    // return FutureBuilder<List<CookieModel>>(
    //   future: _allCookieList,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       if (_filteredCookieList.isEmpty) {
    //         _filteredCookieList = snapshot.data ?? [];
    //       }
    //       return Column(
    //         children: [
    //           ToggleSwitch(
    //             minWidth: MediaQuery.of(context).size.width * 0.8,
    //             initialLabelIndex: 0,
    //             totalSwitches: 3,
    //             labels: const ['Alphabetical', 'Favorites', 'Rating'],
    //             onToggle: (index) {
    //               switch (index) {
    //                 case 0:
    //                   _filteredCookieList.sort(
    //                       (a, b) => a.displayName.compareTo(b.displayName));
    //                   break;
    //                 case 1:
    //                   _filteredCookieList.sort((a, b) {
    //                     if (a.isFavorite && !b.isFavorite) {
    //                       return -1;
    //                     } else if (!a.isFavorite && b.isFavorite) {
    //                       return 1;
    //                     } else {
    //                       return 0;
    //                     }
    //                   });
    //                   break;
    //                 case 2:
    //                   _filteredCookieList
    //                       .sort((a, b) => a.rating.compareTo(b.rating));
    //                   break;
    //               }
    //             },
    //           ),
    //           MyCrumblTextFormField(
    //             controller: _searchBarController,
    //             hintText: 'Search for a cookie by name',
    //             obscureText: false,
    //             validator: null,
    //             prefixIcon: const Icon(Icons.search),
    //             keyboardType: TextInputType.text,
    //             onChanged: _updateFilteredItems,
    //           ),
    //           Expanded(
    //             child: ListView.separated(
    //               padding: const EdgeInsets.all(8.0),
    //               separatorBuilder: (context, index) => const Divider(
    //                   color: CrumblColors.bright1, thickness: 2.0),
    //               shrinkWrap: true,
    //               physics: const ClampingScrollPhysics(),
    //               itemCount: _filteredCookieList.length,
    //               itemBuilder: (context, index) {
    //                 final cookie = _filteredCookieList[index];
    //                 return buildRow(
    //                     context: context,
    //                     controller: _searchBarController,
    //                     cookie: cookie);
    //               },
    //             ),
    //           ),
    //         ],
    //       );
    //     } else if (snapshot.hasError) {
    //       return Text('${snapshot.error}');
    //     } else {
    //       return const Loading();
    //     }
    //   },
    // );
  }
}

Widget buildRow(
    {required context,
    required TextEditingController controller,
    required CookieModel cookie}) {
  const bool isFavorite = true;

  return GestureDetector(
    onTap: () {
      controller.clear();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CookieDetailPage(cookie: cookie),
        ),
      );
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: SizedBox(
            width: 50,
            height: 50,
            child: Hero(
              transitionOnUserGestures: true,
              tag: 'cookie-${cookie.displayName}',
              child: Image.asset(
                cookie.assetPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                cookie.displayName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemSize: MediaQuery.of(context).size.width / 16,
                itemBuilder: (context, _) => const Icon(
                  Icons.cookie,
                  color: CrumblColors.primary,
                ),
                onRatingUpdate: (rating) {
                  //cookie.rating = rating;
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FavoriteButton(
            iconColor: Colors.grey[100],
            iconDisabledColor: Colors.red,
            isFavorite: isFavorite,
            valueChanged: (_) {
              //cookie.isFavorite = !cookie.isFavorite;
            },
          ),
        ),
      ],
    ),
  );
}
