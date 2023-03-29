import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:my_crumbl/pages/home/cookie_detail_page.dart';
import 'package:my_crumbl/services/data_repository.dart';
import 'package:my_crumbl/shared/colors.dart';
import 'package:provider/provider.dart';

class CookieRow extends StatefulWidget {
  CookieModel cookie;

  CookieRow({Key? key, required this.cookie}) : super(key: key);

  @override
  State<CookieRow> createState() => _CookieRowState();
}

class _CookieRowState extends State<CookieRow> {
  @override
  Widget build(BuildContext context) {
    final UserModel? currentUser = Provider.of<UserModel>(context);
    final DataRepository _dataRepository =
        DataRepository(uid: currentUser!.uid);

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) => CookieDetailPage(cookie: widget.cookie),
              ),
            )
            .then((value) => setState(() {}));
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
                  minRating: 0.5,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemSize: MediaQuery.of(context).size.width / 16,
                  itemBuilder: (context, _) => const Icon(
                    Icons.cookie,
                    color: CrumblColors.bright3,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      widget.cookie.rating = rating.toString();
                      _dataRepository.addOrUpdateCookie(widget.cookie);
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: IconButton(
              icon: widget.cookie.isFavorite
                  ? Icon(Icons.favorite,
                      color: Colors.red,
                      size: MediaQuery.of(context).size.width / 12.0)
                  : Icon(Icons.favorite_border,
                      color: Colors.red,
                      size: MediaQuery.of(context).size.width / 12.0),
              onPressed: () => setState(() {
                widget.cookie.isFavorite = !widget.cookie.isFavorite;
                if (widget.cookie.isFavorite) {
                  _dataRepository.addOrUpdateCookie(widget.cookie);
                } else if (!widget.cookie.isFavorite &&
                    double.parse(widget.cookie.rating) > 0) {
                  _dataRepository.addOrUpdateCookie(widget.cookie);
                } else {
                  _dataRepository.deleteCookie(widget.cookie);
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
