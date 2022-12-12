import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wuzzufy_admin/models/Provider.dart';
import 'package:wuzzufy_admin/screens/ConfigureProviderScreen.dart';

class ProviderWidget extends StatelessWidget {
  final Provider provider;

  const ProviderWidget({Key key, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(provider.name),
      subtitle: InkWell(
        child: Text(
            provider.url
                .replaceAll("https://", "")
                .replaceAll("http://", ""),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.blueAccent,
                decoration: TextDecoration.underline)),
        onTap: () {
          open();
        },
      ),
      trailing: Icon(Icons.arrow_back_ios),
      leading: CircleAvatar(
        child: Icon(Icons.work_outline),
        radius: 25,
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ConfigureProviderScreen(
            provider: provider,
          ),
        ));
      },
    );
  }


  open() async {
    String url = provider.url;
    if (url != null && url.isNotEmpty) {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        if (!url.startsWith("http")) {
          url = "http://$url";
        }

        if (await canLaunch(url)) {
          await launch(url);
        } else {
          // error
          EasyLoading.showError("لا يمكن فتح الرابط");
        }
      }
    } else {
      EasyLoading.showError("الرابط فارغ");
    }
  }
}
