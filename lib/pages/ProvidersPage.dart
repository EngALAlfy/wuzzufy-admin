import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:wuzzufy_admin/providers/ProvidersProvider.dart';
import 'package:wuzzufy_admin/utils/Config.dart';
import 'package:wuzzufy_admin/widgets/IsEmptyWidget.dart';
import 'package:wuzzufy_admin/widgets/IsErrorWidget.dart';
import 'package:wuzzufy_admin/widgets/IsLoadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:wuzzufy_admin/widgets/ProviderWidget.dart';

class ProvidersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProvidersProvider provider =
        Provider.of<ProvidersProvider>(context, listen: false);
    provider.getAll(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('المصادر'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(FontAwesome.refresh),
              onPressed: () {
                refresh(context, provider);
              }),
        ],
      ),
      body: Consumer<ProvidersProvider>(
        builder: (context, value, child) {
          if (value.isError) {
            return IsErrorWidget(
              error: value.error,
              onRetry: () {
                refresh(context, value);
              },
            );
          }

          if (value.providers == null) {
            return IsLoadingWidget();
          }

          if (value.providers.isEmpty) {
            return IsEmptyWidget();
          }

          return LazyLoadScrollView(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index == value.providers.length &&
                    value.providers.length < value.count) {
                  return IsLoadingWidget();
                }

                return ProviderWidget(
                  provider: value.providers.elementAt(index),
                );
              },
              itemCount: value.providers.length < value.count
                  ? value.providers.length + 1
                  : value.providers.length,
            ),
            onEndOfPage: () {
              if (value.providers.length < value.count) {
                value.from = value.from + Config.LIST_LIMIT;
                value.getAll(context);
              }
            },
          );
        },
      ),
    );
  }

  refresh(context, provider) {
    provider.clear();
    provider.getAll(context);
  }
}
