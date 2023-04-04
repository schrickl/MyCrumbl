import 'package:flutter/material.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:my_crumbl/pages/home/cookie_row.dart';
import 'package:my_crumbl/services/data_repository.dart';
import 'package:my_crumbl/shared/loading_page.dart';
import 'package:my_crumbl/shared/my_crumbl_text_form_field.dart';
import 'package:provider/provider.dart';

class RatedCookiesTab extends StatefulWidget {
  const RatedCookiesTab({Key? key}) : super(key: key);

  @override
  State<RatedCookiesTab> createState() => _RatedCookiesTabState();
}

class _RatedCookiesTabState extends State<RatedCookiesTab> {
  TextEditingController controller = TextEditingController();

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  List<CookieModel> _getFilteredCookies(List<CookieModel> cookies) {
    final searchQuery = controller.text.toLowerCase();
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

    return StreamBuilder<List<CookieModel>>(
      stream: DataRepository(uid: _currentUser.uid).ratedCookies,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            final cookies = snapshot.data;
            final filteredCookies = _getFilteredCookies(cookies!);

            return Column(
              children: [
                MyCrumblTextFormField(
                  controller: controller,
                  hintText: 'Search for a cookie by name',
                  obscureText: false,
                  validator: null,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.clear();
                      setState(() {});
                    },
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                if (filteredCookies.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'No cookies match the search criteria.',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
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
                        key: Key(cookies.length.toString()),
                        padding: const EdgeInsets.all(8.0),
                        separatorBuilder: (context, index) => Divider(
                            color: Theme.of(context).colorScheme.secondary,
                            thickness: 2.0),
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: filteredCookies.length,
                        itemBuilder: (context, index) {
                          final cookie = filteredCookies[index];
                          return CookieRow(cookie: cookie);
                        },
                      ),
                    ),
                  ),
              ],
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      'Oops! Nothing to see here. Try rating or favoriting some cookies!',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
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
