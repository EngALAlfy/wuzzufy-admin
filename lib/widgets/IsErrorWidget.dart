import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';

class IsErrorWidget extends StatelessWidget {
  final String error;
  final Function onRetry;

  const IsErrorWidget({Key key, this.error, this.onRetry}) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 128,
                color: Colors.grey,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "حدث خطأ",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                    fontSize: 30),
              ),
              (error != null && error.isNotEmpty)
                  ? Text(
                      error,
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w200,
                          fontSize: 20),
                    )
                  : Container(
                      height: 0,
                      width: 0,
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
          if (onRetry != null) {
            onRetry();
          }
        },
      ),
    );
  }
}
