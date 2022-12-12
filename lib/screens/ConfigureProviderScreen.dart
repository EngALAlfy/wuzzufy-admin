import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wuzzufy_admin/models/Provider.dart' as model;
import 'package:wuzzufy_admin/providers/ProvidersProvider.dart';

class ConfigureProviderScreen extends StatelessWidget {
  final model.Provider provider;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  ConfigureProviderScreen({Key key, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProvidersProvider providersProvider =
        Provider.of<ProvidersProvider>(context, listen: false);
    providersProvider.getProviderConfig(provider.id);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(provider.name),
        ),
        body: Consumer<ProvidersProvider>(
          builder: (context, value, child) {
            return ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: Text("كلاس العنوان"),
                  subtitle: Text(value.titleClassName),
                  trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _titleController.text = value.titleClassName;

                        Alert(
                          context: context,
                          title: "تغيير كلاس العنوان",
                          content: TextField(
                            controller: _titleController,
                          ),
                          closeFunction: () {
                            _titleController.text = null;
                          },
                          buttons: [
                            DialogButton(
                              child: Text("موافق"),
                              onPressed: () {
                                value.titleClassName = _titleController.text;
                                value.setProviderTitleConfig(provider.id);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ).show();
                      }),
                ),
                ListTile(
                  title: Text("كلاس الوصف"),
                  subtitle: Text(value.descClassName),
                  trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _descController.text = value.descClassName;
                        Alert(
                          context: context,
                          title: "تغيير كلاس الوصف",
                          content: TextField(
                            controller: _descController,
                          ),
                          closeFunction: () {
                            _descController.text = null;
                          },
                          buttons: [
                            DialogButton(
                              child: Text("موافق"),
                              onPressed: () {
                                value.descClassName = _descController.text;
                                value.setProviderDescConfig(provider.id);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ).show();
                      }),
                ),
              ],
            );
          },
        ));
  }
}
