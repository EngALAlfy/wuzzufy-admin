import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';
import 'package:wuzzufy_admin/providers/JobsProvider.dart';

class AddJobScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    JobsProvider jobsProvider = Provider.of<JobsProvider>(context , listen: false);
    jobsProvider.getCategories(context);
    jobsProvider.getProviders(context);

    FlutterClipboard.paste().then((value){
      if(value != null && value.isNotEmpty && value.startsWith("http")){
        jobsProvider.url = value;
        //jobsProvider.getProviderFromUrl();
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("اضافة وظيفة جديدة"),
      ),
      body: Consumer<JobsProvider>(
        builder: (context, value, child) {
          _titleController.text = value.title;
          _descController.text = value.desc;
          _urlController.text = value.url;
          print("id : ${value.provider_id}");
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: "عنوان الوظيفة"),
                      validator: RequiredValidator(errorText: "ادخل عنوان الوظيفة"),
                      onSaved: (newValue) => value.title = newValue,
                    ),
                    TextFormField(
                      controller: _descController,
                      decoration: InputDecoration(labelText: "وصف الوظيفة"),
                      keyboardType: TextInputType.multiline,
                      minLines: 4,
                      maxLines: null,
                      validator: RequiredValidator(errorText: "ادخل وصف الوظيفة"),
                      onSaved: (newValue) => value.desc = newValue,
                    ),
                    TextFormField(
                      validator: RequiredValidator(errorText: "ادخل رابط الوظيفة"),
                      controller: _urlController,
                      decoration: InputDecoration(
                          labelText: "رابط الوظيفة",
                          suffixIcon: Wrap(
                            direction: Axis.horizontal,
                            children: [
                              IconButton(
                                onPressed: () {
                                  value.url = null;
                                  _urlController.clear();
                                  value.update();
                                },
                                icon: Icon(Icons.clear),
                              ),
                              SizedBox(width: 5,),
                              IconButton(
                                onPressed: () {
                                  FlutterClipboard.paste().then((v){
                                    value.url = v;
                                    //value.getProviderFromUrl();
                                    value.update();
                                  });
                                },
                                icon: Icon(Icons.paste),
                              )
                            ],
                          ),),
                      onSaved: (newValue) => value.url = newValue,
                    ),
                    SmartSelect<int>.single(
                      title: 'الاقسام',
                      value: value.category_id,
                      choiceItems: value.categories,
                      modalType: S2ModalType.bottomSheet,
                      choiceType: S2ChoiceType.radios,
                      onChange: (state) {
                        value.category_id = state.value;
                      },
                      tileBuilder: (context, state) {
                        return S2Tile.fromState(
                          state,
                          isTwoLine: true,
                          trailing: Icon(Icons.keyboard_arrow_left_rounded),
                        );
                      },
                    ),
                    SmartSelect<int>.single(
                      title: 'المصادر',
                      value: value.provider_id,
                      choiceItems: value.providers,
                      modalType: S2ModalType.fullPage,
                      choiceType: S2ChoiceType.radios,
                      onChange: (state) {
                        value.provider_id = state.value;
                      },
                      tileBuilder: (context, state) {
                        return S2Tile.fromState(
                          state,
                          isTwoLine: true,
                          trailing: Icon(Icons.keyboard_arrow_left_rounded),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        children: [
          FloatingActionButton(
            heroTag: "save",
            child: Icon(Icons.save),
            onPressed: () {
              if (!_formKey.currentState.validate()) {
                return;
              }
              _formKey.currentState.save();
              jobsProvider.add(context);
            },
          ),

          SizedBox(width: 20,),
          FloatingActionButton(
            heroTag: "get",
            child: Icon(Icons.get_app_outlined),
            onPressed: () {
              EasyLoading.show();
              jobsProvider.url = _urlController.text;
              jobsProvider.getJobContentFromUrl(context);
            },
          ),
          SizedBox(width: 20,),
          FloatingActionButton(
            heroTag: "clear",
            child: Icon(Icons.clear),
            onPressed: () {
              jobsProvider.title = "";
              jobsProvider.desc = "";
              jobsProvider.url = "";
              _formKey.currentState.reset();
              jobsProvider.update();
              //jobsProvider.add(context);
            },
          ),
        ],
      ),
    );
  }


}
