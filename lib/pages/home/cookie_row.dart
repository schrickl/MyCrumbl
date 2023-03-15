import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:my_crumbl/pages/home/cookie_detail_page.dart';
import 'package:my_crumbl/services/data_repository.dart';
import 'package:my_crumbl/shared/colors.dart';
import 'package:provider/provider.dart';

class CookieRow extends StatefulWidget {
  final TextEditingController controller;
  CookieModel cookie;

  CookieRow({Key? key, required this.controller, required this.cookie})
      : super(key: key);

  @override
  State<CookieRow> createState() => _CookieRowState();
}

class _CookieRowState extends State<CookieRow> {
  bool get isFavorite => false;

  @override
  Widget build(BuildContext context) {
    final UserModel? currentUser = Provider.of<UserModel>(context);
    final DataRepository _dataRepository =
        DataRepository(uid: currentUser!.uid);

    return GestureDetector(
      onTap: () {
        widget.controller.clear();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CookieDetailPage(cookie: widget.cookie),
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
                tag: 'cookie-${widget.cookie.displayName}',
                child: Image.asset(
                  widget.cookie.assetPath,
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
                  widget.cookie.displayName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                RatingBar.builder(
                  initialRating: double.parse(widget.cookie.rating),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemSize: MediaQuery.of(context).size.width / 16,
                  itemBuilder: (context, _) => const Icon(
                    Icons.cookie,
                    color: CrumblColors.bright4,
                  ),
                  onRatingUpdate: (rating) {
                    widget.cookie.rating = rating.toString();
                    _dataRepository.updateCookieModel(widget.cookie);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FavoriteButton(
              isFavorite: widget.cookie.isFavorite,
              valueChanged: (_) {
                widget.cookie.isFavorite = !widget.cookie.isFavorite;
                _dataRepository.updateCookieModel(widget.cookie);
              },
            ),
          ),
        ],
      ),
    );
  }
}
