import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';

class IsEmptyWidget extends StatelessWidget {

  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.clear,
                size: 128,
                color: Colors.grey,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "لا يوجد بيانات",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                    fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "اضغط لاعادة المحاولة",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                    fontSize: 25),
              ),
            ],
          ),
        ),
        onTap: () {

        },
      ),
    );
  }
}
