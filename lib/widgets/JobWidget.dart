import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:wuzzufy_admin/models/Job.dart';
import 'package:wuzzufy_admin/providers/JobsProvider.dart';
import 'package:wuzzufy_admin/utils/timeAgo.dart' as timeAgo;
import 'package:url_launcher/url_launcher.dart';

class JobWidget extends StatefulWidget {
  final Job job;

  const JobWidget({Key key, this.job}) : super(key: key);

  @override
  _JobWidgetState createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      color: Colors.grey.shade100,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          providerInfo(),
          SizedBox(
            height: 20,
          ),
          jobInfo(),
          SizedBox(
            height: 10,
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          timeAndUserInfo(),
          SizedBox(
            height: 20,
          ),
          buttons(),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  providerInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.job.provider.name,
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                  widget.job.provider.url
                      .replaceAll("https://", "")
                      .replaceAll("http://", ""),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline)),
            ],
          ),
        ),
      ],
    );
  }

  jobInfo() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: Text(
              widget.job.title,
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(widget.job.desc),
        ],
      ),
    );
  }

  timeAndUserInfo() {
    return Row(
      children: [
        Text(
          timeAgo.format(DateTime.parse(widget.job.createdAt)),
          style: TextStyle(color: Colors.grey),
        ),
        Spacer(),
        Text(
          " بواسطة ${widget.job.added_admin.name}",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  buttons() {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        TextButton.icon(
          icon: Icon(Icons.notifications_active_outlined),
          onPressed: () {
            Provider.of<JobsProvider>(context, listen: false)
                .notify(context, widget.job.id);
          },
          label: Text("ارسال اشعار"),
        ),
        TextButton.icon(
          icon: Icon(FontAwesome5Brands.telegram),
          onPressed: () {
            Provider.of<JobsProvider>(context, listen: false)
                .telegram(context, widget.job.id);
          },
          label: Text("ارسال تليجرام"),
        ),
        TextButton.icon(
          icon: Icon(FontAwesome.copy),
          onPressed: () {

            copy();},
          label: Text("نسخ"),
        ),
      ],
    );
  }

  void copy() async {
    var text = "${widget.job.title}\n"
        "https://wuzzufy.me/${widget.job.id}";
   await FlutterClipboard.copy(text);
   EasyLoading.showSuccess("تم النسخ");
  }
}
