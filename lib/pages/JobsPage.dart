import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wuzzufy_admin/providers/AuthProvider.dart';
import 'package:wuzzufy_admin/providers/JobsProvider.dart';
import 'package:wuzzufy_admin/providers/UtilsProvider.dart';
import 'package:wuzzufy_admin/screens/AddJobScreen.dart';
import 'package:wuzzufy_admin/utils/Config.dart';
import 'package:provider/provider.dart';
import 'package:wuzzufy_admin/widgets/IsEmptyWidget.dart';
import 'package:wuzzufy_admin/widgets/IsErrorWidget.dart';
import 'package:wuzzufy_admin/widgets/IsLoadingWidget.dart';
import 'package:wuzzufy_admin/widgets/JobWidget.dart';

class JobsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    JobsProvider provider = Provider.of<JobsProvider>(context, listen: false);

    provider.from = 0;
    provider.count = 0;
    provider.getAll(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('الوظايف'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(FontAwesome.refresh),
              onPressed: () {
                refresh(context, provider);
              }),
          IconButton(
              icon: Icon(FontAwesome.info_circle),
              onPressed: () {
                Alert(
                  context: context,
                  type: AlertType.info,
                  title: "بيانات الادمن",
                  content: Container(
                    child: Consumer<JobsProvider>(
                      builder: (context, value, child) {
                        if (value.admin == null) {
                          return IsLoadingWidget();
                        }

                        return ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            child: Icon(Feather.user_check),
                          ),
                          title: Text(value.admin.name),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("اسم المستخدم : ${value.admin.username}"),
                              Text("البريد : ${value.admin.email}"),
                              Text("الاي دي : ${value.admin.id}"),
                              TextButton.icon(
                                  onPressed: () {
                                    context.read<AuthProvider>().unAuth();
                                  },
                                  icon: Icon(Icons.logout),
                                  label: Text("تسجيل خروج")),
                            ],
                          ),
                        );
                      },
                    ),
                    width: double.infinity,
                    height: 200,
                  ),
                ).show();
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddJobScreen(),
          ));
        },
        child: Icon(Icons.add),
      ),
      body: Consumer<JobsProvider>(
        builder: (context, value, child) {
          if (value.isError) {
            return IsErrorWidget(
              error: value.error,
              onRetry: () {
                refresh(context, provider);
              },
            );
          }

          if (value.jobs == null) {
            return IsLoadingWidget();
          }

          if (value.jobs.isEmpty) {
            return IsEmptyWidget();
          }

          return LazyLoadScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index == value.jobs.length &&
                    value.jobs.length < value.count) {
                  return IsLoadingWidget();
                }

                return JobWidget(
                  job: value.jobs.elementAt(index),
                );
              },
              itemCount: value.jobs.length < value.count
                  ? value.jobs.length + 1
                  : value.jobs.length,
            ),
            onEndOfPage: () {
              if (value.jobs.length < value.count) {
                value.from = value.from + Config.LIST_LIMIT;
                value.getAll(context);
              }
            },
          );
        },
      ),
    );
  }

  refresh(context, JobsProvider provider) {
    provider.clear();
    provider.getAll(context);
  }
}
