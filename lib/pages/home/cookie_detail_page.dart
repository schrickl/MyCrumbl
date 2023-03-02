import 'package:cached_network_image/cached_network_image.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/services/storage_service.dart';
import 'package:my_crumbl/shared/colors.dart';

class CookieDetailPage extends StatefulWidget {
  final CookieModel cookie;

  const CookieDetailPage({Key? key, required this.cookie}) : super(key: key);

  @override
  State<CookieDetailPage> createState() => _CookieDetailPageState();
}

class _CookieDetailPageState extends State<CookieDetailPage> {
  final StorageService _storageService = StorageService();
  String _downloadUrl = '';

  @override
  Widget build(BuildContext context) {
    const bool isFavorite = true;

    return Scaffold(
      backgroundColor: CrumblColors.secondary,
      appBar: AppBar(
        title: Text(widget.cookie.displayName!),
        backgroundColor: CrumblColors.primary,
        elevation: 0,
      ),
      extendBodyBehindAppBar: false,
      body: FutureBuilder<String>(
        future: _storageService.getSingleImageUrl(widget.cookie),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _downloadUrl = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ClipRRect(
                  child: Hero(
                    transitionOnUserGestures: true,
                    tag: 'cookie-${widget.cookie.displayName}',
                    child: CachedNetworkImage(
                      imageUrl: _downloadUrl,
                      height: 240,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ListTile(
                  title: Text(
                    widget.cookie.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: CrumblColors.bright3,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      widget.cookie.description,
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  trailing: FavoriteButton(
                    iconColor: Colors.grey[100],
                    iconDisabledColor: Colors.red,
                    isFavorite: isFavorite,
                    valueChanged: (_) {},
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemSize: 65.0,
                      itemBuilder: (context, _) => const Icon(
                        Icons.cookie,
                        color: CrumblColors.primary,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
