import 'package:flutter/material.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:my_crumbl/pages/home/cookie_row.dart';
import 'package:my_crumbl/services/data_repository.dart';
import 'package:my_crumbl/shared/colors.dart';
import 'package:my_crumbl/shared/loading_page.dart';
import 'package:my_crumbl/shared/my_crumbl_text_form_field.dart';
import 'package:provider/provider.dart';

class AllCookiesTab extends StatefulWidget {
  const AllCookiesTab({Key? key}) : super(key: key);

  @override
  State<AllCookiesTab> createState() => _AllCookiesTabState();
}

class _AllCookiesTabState extends State<AllCookiesTab> {
  final TextEditingController _controller = TextEditingController();
  List<CookieModel> _filteredCookies = [];

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<CookieModel> _getFilteredCookies(List<CookieModel> cookies) {
    final searchQuery = _controller.text.toLowerCase();
    if (searchQuery.isEmpty) {
      return cookies;
    }

    return cookies
        .where(
            (cookie) => cookie.displayName.toLowerCase().contains(searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final _currentUser = Provider.of<UserModel>(context);
    final _dataRepository = DataRepository(uid: _currentUser.uid);

    return StreamBuilder<List<CookieModel>>(
      stream: DataRepository(uid: _currentUser.uid).mergedCookiesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            final cookies = snapshot.data;
            _filteredCookies = _getFilteredCookies(cookies!);
            _dataRepository.syncMyCookiesWithAllCookies();

            return Column(
              children: [
                MyCrumblTextFormField(
                  controller: _controller,
                  hintText: 'Search for a cookie by name',
                  obscureText: false,
                  validator: null,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      setState(() {});
                    },
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                if (_filteredCookies.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'No cookies match the search criteria.',
                        style: TextStyle(
                            color: CrumblColors.bright1,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.separated(
                        key: Key(cookies[0].displayName),
                        padding: const EdgeInsets.all(8.0),
                        separatorBuilder: (context, index) => const Divider(
                            color: CrumblColors.bright1, thickness: 2.0),
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: _filteredCookies.length,
                        itemBuilder: (context, index) {
                          final cookie = _filteredCookies[index];
                          return CookieRow(cookie: cookie);
                        },
                      ),
                    ),
                  ),
              ],
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
    );
  }
}
