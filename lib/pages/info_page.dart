import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  PackageInfo? packageInfo;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await PackageInfo.fromPlatform().then((value) {
        setState(() {
          packageInfo = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'MyCrumbl Info',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('Credit for cookie images goes to:',
                style: Theme.of(context).textTheme.headlineSmall),
          ),
          ListTile(
            title: const Text(
              'Crumbl Cookies®',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                decoration: TextDecoration.underline,
              ),
            ),
            onTap: () async {
              await launch(Uri.parse('https://crumblcookies.com/index.html'));
            },
          ),
          ListTile(
            title: const Text(
              'Brand Eating',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                decoration: TextDecoration.underline,
              ),
            ),
            onTap: () async {
              await launch(Uri.parse('https://www.brandeating.com/'));
            },
          ),
          ListTile(
            title: const Text(
              'Lifestyle of a Foodie',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                decoration: TextDecoration.underline,
              ),
            ),
            onTap: () async {
              await launch(Uri.parse('https://lifestyleofafoodie.com/'));
            },
          ),
          ListTile(
            title: const Text(
              'Salt & Baker',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                decoration: TextDecoration.underline,
              ),
            ),
            onTap: () async {
              await launch(Uri.parse('https://saltandbaker.com/'));
            },
          ),
          const SizedBox(height: 20),
          Divider(
            color: Theme.of(context).colorScheme.secondary,
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(height: 20),
          Text(
            'Version Number: ${packageInfo?.version}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width / 16,
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        height: 50,
        child: ListTile(
          title: const Text(
            'Privacy Policy',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
              decoration: TextDecoration.underline,
            ),
          ),
          onTap: () async {
            await launch(Uri.parse(
                'https://www.freeprivacypolicy.com/live/1282bd9f-6bd1-44f1-9da8-3ff1e9893d9f'));
          },
        ),
      ),
    );
  }

  Future<void> launch(Uri url) async {
    try {
      await launchUrl(url);
    } catch (e) {
      print('Could not launch $url');
    }
  }
}
