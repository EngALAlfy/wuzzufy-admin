
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wuzzufy_admin/providers/UsersProvider.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<UsersProvider>(context , listen: false).getStatistics(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("احصائيات"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        key: PageStorageKey<int>(1),
        child: Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Card(
                    shadowColor: Colors.grey,
                    elevation: 5,
                    color: Colors.orangeAccent,
                    child: Container(
                      child: Column(
                        children: [
                          Consumer<UsersProvider>(builder: (context, value, child) {
                            if(value.statistics == null ){
                              return Center(child: CircularProgressIndicator(),);
                            }

                            return Text("${value.statistics["day"]} مستخدم ", style: TextStyle(color: Colors.white , fontSize: 25 , fontWeight: FontWeight.bold),);
                          },),
                          Divider(color:Colors.black),
                          Text("اخر ظهور في خلال 24 ساعه",style: TextStyle(color: Colors.white , fontSize: 13),),
                        ],
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 20 ,vertical: 10),
                    ),
                  ),),
                  Expanded(child: Card(
                    shadowColor: Colors.grey,
                    elevation: 5,
                    color: Colors.blueAccent,
                    child: Container(
                      child: Column(
                        children: [
                          Consumer<UsersProvider>(builder: (context, value, child) {
                            if(value.statistics == null ){

                              return Center(child: CircularProgressIndicator(),);                          }

                            return Text("${value.statistics["week"]} مستخدم ", style: TextStyle(color: Colors.white , fontSize: 25 , fontWeight: FontWeight.bold),);
                          },),
                          Divider(color:Colors.black),
                          Text("اخر ظهور في خلال اسبوع",style: TextStyle(color: Colors.white , fontSize: 13),),
                        ],
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 20 ,vertical: 10),
                    ),
                  ),),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Card(
                    shadowColor: Colors.grey,
                    elevation: 5,
                    color: Colors.purpleAccent,
                    child: Container(
                      child: Column(
                        children: [
                          Consumer<UsersProvider>(builder: (context, value, child) {
                            if(value.statistics == null ){

                              return Center(child: CircularProgressIndicator(),);                          }

                            return Text("${value.statistics["month"]} مستخدم ", style: TextStyle(color: Colors.white , fontSize: 25 , fontWeight: FontWeight.bold),);
                          },),
                          Divider(color:Colors.black),
                          Text("اخر ظهر في خلال شهر",style: TextStyle(color: Colors.white , fontSize: 13),),
                        ],
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 20 ,vertical: 10),
                    ),
                  ),),
                  Expanded(child: Card(
                    shadowColor: Colors.grey,
                    elevation: 5,
                    color: Colors.deepOrangeAccent,
                    child: Container(
                      child: Column(
                        children: [
                          Consumer<UsersProvider>(builder: (context, value, child) {
                            if(value.statistics == null ){

                              return Center(child: CircularProgressIndicator(),);                          }

                            return Text("${value.statistics["all"]} مستخدم ", style: TextStyle(color: Colors.white , fontSize: 25 , fontWeight: FontWeight.bold),);
                          },),
                          Divider(color:Colors.black),
                          Text("كل المستخدمين",style: TextStyle(color: Colors.white , fontSize: 13),),
                        ],
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 20 ,vertical: 10),
                    ),
                  ),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
