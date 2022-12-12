import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/dom.dart' as html;

class JobContentScreen extends StatelessWidget {
  final html.Document document;

  const JobContentScreen({Key key, this.document}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var body = document.body.innerHtml;
    return Scaffold(
      body: SingleChildScrollView(child: HtmlWidget(
         body ,
          webView: false,
          webViewJs: false,
          webViewDebuggingEnabled: false,
          webViewMediaPlaybackAlwaysAllow: false,
          customWidgetBuilder: (element) {
            return elementListView(element);
          },
      ),
      ),
    );
  }

  nodeListView(html.Element parent){
    var parentN = parent.nodes;
    parentN.removeWhere((nod) {
          return nod.text.trim().isEmpty;
      } );

    //print(parentN.elementAt(0));

    return  ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index){

        print("index : $index = ${parentN.elementAt(index)}");

        return Container(
          child: Column(
              children: [
                parentN.elementAt(index).hasChildNodes() ? elementListView(parentN.elementAt(index)) : InkWell(child: Text(parentN.elementAt(index).text),onTap: ()=>print(parentN.elementAt(index).text),),
              ]
          ),
          color: Colors.primaries.elementAt(index > Colors.primaries.length ? index - 1 : index),
        );
      },
      itemCount: parentN.length,);
  }


  elementListView(html.Element parent){

    return  ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index){

        return Container(
          child: Column(
              children: [
                InkWell(child: HtmlWidget(parent.children.elementAt(index).innerHtml),onTap: ()=>print(parent.children.elementAt(index).text),),
              ]
          ),
          color: Colors.primaries.elementAt(index > Colors.primaries.length ? index - 1 : index),
        );
      },
      itemCount: parent.children.length,);
  }
}
