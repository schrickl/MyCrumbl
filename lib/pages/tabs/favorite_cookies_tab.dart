import 'package:flutter/material.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/pages/home/cookie_row.dart';
import 'package:my_crumbl/shared/colors.dart';
import 'package:my_crumbl/shared/my_crumbl_text_form_field.dart';
import 'package:provider/provider.dart';

class FavoriteCookiesTab extends StatefulWidget {
  const FavoriteCookiesTab({Key? key}) : super(key: key);

  @override
  State<FavoriteCookiesTab> createState() => _FavoriteCookiesTabState();
}

class _FavoriteCookiesTabState extends State<FavoriteCookiesTab> {
  TextEditingController controller = TextEditingController();
  List<CookieModel> _filteredCookieList = [];

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  List<CookieModel> _updateFilteredItems(
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
    final cookies = Provider.of<List<CookieModel>>(context);

    return Column(
      children: [
        MyCrumblTextFormField(
          controller: controller,
          hintText: 'Search for a cookie by name',
          obscureText: false,
          validator: null,
          prefixIcon: const Icon(Icons.search),
          keyboardType: TextInputType.text,
          onChanged: (value) {
            setState(() {
              _updateFilteredItems(value, cookies);
            });
          },
        ),
        Consumer<List<CookieModel>>(
          builder: (_, cookies, __) => Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8.0),
              separatorBuilder: (context, index) =>
                  const Divider(color: CrumblColors.bright1, thickness: 2.0),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: _filteredCookieList.isNotEmpty
                  ? _filteredCookieList.length
                  : cookies.length,
              itemBuilder: (context, index) {
                return CookieRow(
                    controller: controller,
                    cookie: _filteredCookieList.isNotEmpty
                        ? _filteredCookieList[index]
                        : cookies[index]);
              },
            ),
          ),
        ),
      ],
    );
  }
}
