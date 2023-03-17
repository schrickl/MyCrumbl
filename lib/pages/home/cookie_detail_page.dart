import 'package:cached_network_image/cached_network_image.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:my_crumbl/services/data_repository.dart';
import 'package:my_crumbl/services/storage_service.dart';
import 'package:my_crumbl/shared/colors.dart';
import 'package:my_crumbl/shared/loading_page.dart';
import 'package:provider/provider.dart';

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
    final UserModel? currentUser = Provider.of<UserModel>(context);
    final DataRepository _dataRepository =
        DataRepository(uid: currentUser!.uid);

    return Scaffold(
      backgroundColor: CrumblColors.secondary,
      appBar: AppBar(
        title: Text(widget.cookie.displayName),
        backgroundColor: CrumblColors.primary,
        elevation: 0,
      ),
      extendBodyBehindAppBar: false,
      body: FutureBuilder<String>(
        future: _storageService.getSingleImageUrl(widget.cookie),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _downloadUrl = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ClipRRect(
                    child: Hero(
                      transitionOnUserGestures: true,
                      tag: 'cookie-${widget.cookie.displayName}',
                      child: CachedNetworkImage(
                        imageUrl: _downloadUrl,
                        height: MediaQuery.of(context).size.height * 0.5,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        placeholder: (context, url) => const LoadingPage(),
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
                      isFavorite: widget.cookie.isFavorite,
                      valueChanged: (value) {
                        setState(() {
                          widget.cookie.isFavorite = value;
                        });
                        if (widget.cookie.isFavorite) {
                          _dataRepository.addOrUpdateCookie(widget.cookie);
                        } else if (!widget.cookie.isFavorite &&
                            double.parse(widget.cookie.rating) > 0) {
                          _dataRepository.addOrUpdateCookie(widget.cookie);
                        } else {
                          _dataRepository.deleteCookie(widget.cookie);
                        }
                      },
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: RatingBar.builder(
                        initialRating: double.parse(widget.cookie.rating),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemSize: MediaQuery.of(context).size.width / 8,
                        itemBuilder: (context, _) => const Icon(
                          Icons.cookie,
                          color: CrumblColors.bright4,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            widget.cookie.rating = rating.toString();
                          });
                          _dataRepository.addOrUpdateCookie(widget.cookie);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const LoadingPage();
          }
        },
      ),
    );
  }
}
