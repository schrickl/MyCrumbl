import 'package:flutter/material.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/pages/home/cookie_row.dart';
import 'package:my_crumbl/shared/colors.dart';
import 'package:my_crumbl/shared/my_crumbl_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CookieList extends StatefulWidget {
  const CookieList({Key? key}) : super(key: key);

  @override
  State<CookieList> createState() => _CookieListState();
}

class _CookieListState extends State<CookieList> {
  final _searchBarController = TextEditingController();
  List<CookieModel> _filteredCookieList = [];

  @override
  void dispose() {
    _searchBarController.dispose();
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
        ToggleSwitch(
          minWidth: MediaQuery.of(context).size.width * 0.8,
          initialLabelIndex: 0,
          totalSwitches: 3,
          labels: const ['All', 'Favorites', 'Rating'],
          onToggle: (index) {
            switch (index) {
              case 0:
                _filteredCookieList
                    .sort((a, b) => a.displayName.compareTo(b.displayName));
                break;
              case 1:
                _filteredCookieList.sort((a, b) {
                  if (a.isFavorite! && !b.isFavorite!) {
                    return -1;
                  } else if (!a.isFavorite! && b.isFavorite!) {
                    return 1;
                  } else {
                    return 0;
                  }
                });
                break;
              case 2:
                _filteredCookieList
                    .sort((a, b) => a.rating!.compareTo(b.rating!));
                break;
            }
          },
        ),
        MyCrumblTextFormField(
          controller: _searchBarController,
          hintText: 'Search for a cookie by name',
          obscureText: false,
          validator: null,
          prefixIcon: const Icon(Icons.search),
          keyboardType: TextInputType.text,
          onChanged: (value) {
            setState(() {
              print('fil: ' + _filteredCookieList.length.toString());
              _updateFilteredItems(value, cookies);
            });
          },
        ),
        Expanded(
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
                  controller: _searchBarController,
                  cookie: _filteredCookieList.isNotEmpty
                      ? _filteredCookieList[index]
                      : cookies[index]);
            },
          ),
        ),
      ],
    );
  }
}
