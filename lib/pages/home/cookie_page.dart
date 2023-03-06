import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/pages/home/cookie_detail_page.dart';
import 'package:my_crumbl/services/auth_service.dart';
import 'package:my_crumbl/services/firestore_service.dart';
import 'package:my_crumbl/shared/colors.dart';

class CookiePage extends StatefulWidget {
  const CookiePage({super.key});

  @override
  State<CookiePage> createState() => _CookiePageState();
}

class _CookiePageState extends State<CookiePage> {
  final AuthService _auth = AuthService();
  final FirestoreService _firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: FutureBuilder<List<CookieModel>>(
        future: _firestore.fetchAllCookies(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<CookieModel> cookieList = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(8.0),
              separatorBuilder: (context, index) =>
                  const Divider(color: CrumblColors.bright1, thickness: 2.0),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: cookieList.length,
              itemBuilder: (context, index) {
                final cookie = cookieList[index];
                return buildRow(context: context, cookie: cookie);
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

Widget buildRow({required context, required CookieModel cookie}) {
  bool isFavorite = true;

  return GestureDetector(
    onTap: () {
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
                  print(rating);
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
            valueChanged: (_) {},
          ),
        ),
      ],
    ),
  );
}
