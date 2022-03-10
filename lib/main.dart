import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final SnackBar loading = SnackBar(content: Text("LOADING...", style: TextStyle(color: Colors.white),));
  final String _url = "https://type.fit/api/quotes";
  String _text = "";
  String _author = "";
  static int i = 0;

  @override
  void initState() {
    super.initState();
    this._getData(context);
  }

  Future<String> _getData(BuildContext context) async{
    var res = await http.get(Uri.encodeFull(_url), headers: {"Accept": "application/json"});
    if(res == null){

    }
    setState(() {
      var resBody = json.decode(res.body);
      _text = resBody[i]["text"];
      if(resBody[i]["author"] == null){
        _author = "";
      }else{
        _author = "-" + resBody[i]["author"];
      }
    });
    Scaffold.of(context).hideCurrentSnackBar();
    return "Sucess!";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Quotes"),
          centerTitle: true,
          elevation: 0,
        ),
        body: Builder(builder: (context){
          return SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 150,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      _text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 125.0),
                    child: Container(
                      child: Text(
                        "$_author",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.green,
                        child: Text("PREVIOUS"),
                        onPressed: (){
                          setState(() {
                            if(i == 0){
                              i = 1642;
                            }else{
                              i--;
                            }
                            Scaffold.of(context).showSnackBar(loading);
                            _getData(context);
                          });
                        },
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      RaisedButton(
                        color: Colors.green,
                        child: Text("NEXT"),
                        onPressed: (){
                          setState(() {
                            if(i > 1642){
                              i=0;
                            }else{
                              i++;
                            }
                            Scaffold.of(context).showSnackBar(loading);
                            _getData(context);
                          });
                        },
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        })
    );
  }
}
