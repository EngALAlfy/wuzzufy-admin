import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:wuzzufy_admin/providers/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 150,
              ),
              Text(
                "#وظايفي",
                style: TextStyle(fontSize: 40),
              ),
              Text(
                "اكبر تجمع للوظايف بين ايديك",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(
                height: 20,
              ),
              usernameTextField(context, authProvider),
              SizedBox(
                height: 10,
              ),
              passwordTextField(context, authProvider),
              SizedBox(
                height: 5,
              ),
              loginBtn(context, authProvider),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  usernameTextField(context, usersProvider) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: TextFormField(
          onSaved: (newValue) {
            usersProvider.loginId = newValue;
          },
          validator: RequiredValidator(errorText: 'يرجي ادخال اسم المستخدم'),
          decoration: InputDecoration(
            labelText: "اسم المستخدم",
            labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(20)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
                borderRadius: BorderRadius.circular(20)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[300]),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor, width: 1.0)),
            prefixIcon: const Icon(
              FontAwesome.user,
            ),
          ),
          obscureText: false,
        ),
      ),
    );
  }

  passwordTextField(context, usersProvider) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(right: 20, left: 20, bottom: 10),
        child: TextFormField(
          validator: RequiredValidator(errorText: 'يرجي ادخال كلمة السر'),
          onSaved: (newValue) {
            usersProvider.password = newValue;
          },
          obscureText: true,
          decoration: InputDecoration(
            labelText: "كلمة السر",
            labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
            hintStyle: TextStyle(fontSize: 14),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey, width: 1.0)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
                borderRadius: BorderRadius.circular(20)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[300]),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor, width: 1.0)),
            prefixIcon: const Icon(
              Icons.lock,
            ),
          ),
        ),
      ),
    );
  }

  loginBtn(context,AuthProvider authProvider) {
    return Container(
      width: 200,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Padding(
        padding: EdgeInsets.only(),
        child: FlatButton.icon(
          icon: Icon(
            FontAwesome.sign_in,
            color: Colors.grey,
          ),
          onPressed: () {
            if (!_formKey.currentState.validate()) {
              return;
            }

            _formKey.currentState.save();

            authProvider.loginWithUsername(context);
          },
          label: Text(
            "دخول",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
