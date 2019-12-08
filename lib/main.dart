import 'package:todo/UI/Intray/intray_page.dart';
import 'package:flutter/material.dart';
import 'models/globals.dart';
import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.reference();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        dialogBackgroundColor: Colors.transparent
      ),
      home: MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return getHomePage();
        },
      );
}

Widget getHomePage(){
  return MaterialApp(
      color: Colors.yellow,
      home: SafeArea(
      child: DefaultTabController(
        length: 3,
        child: new Scaffold(
          body: Stack(
          children:<Widget>[
              TabBarView(
              children: [
                new IntrayPage(),
                new Container(
                  color: Colors.orange,
                  ),
                new Container(
                  color: Colors.lightGreen,
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 50),
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50)
                ),
                color: fcolor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Intray", style: intrayTitleStyle,),
                  Container()
                ],
              ),
            ),
            Container(
              height: 80,
              width: 80,
              margin: EdgeInsets.only(top:120, left: MediaQuery.of(context).size.width*0.5-40),
              child: FloatingActionButton(
                child: Icon(Icons.add,size: 70,),
                backgroundColor: redColor,
                onPressed:_showAddDialog,
              ),
            )
          ]
          ),
          appBar: AppBar(
            elevation: 0,
            title: new TabBar(
              tabs: [
                Tab(
                  icon: new Icon(Icons.home),
                ),
                Tab(
                  icon: new Icon(Icons.rss_feed),
                ),
                Tab(
                  icon: new Icon(Icons.perm_identity),
                ),
                
              ],
              labelColor: Colors.white,
              unselectedLabelColor: redColor,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.all(5.0),
              indicatorColor: Colors.transparent,
            ),
            backgroundColor: fcolor,
          ),
          backgroundColor: fcolor,
        ),
      ),
      ),
    );
  }

void _showAddDialog(){
    TextEditingController taskName = new TextEditingController();
    TextEditingController note = new TextEditingController();
    // flutter defined function
        showDialog(
        context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Container(
            padding: EdgeInsets.all(20),
            constraints: BoxConstraints.expand(height: 250,),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(13)),
              color: darkGreyColor
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Add New Task", style: whiteTitle),
                Container(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: taskName,
                      decoration: InputDecoration(
                        hintText: "Name of task",
                        enabledBorder: UnderlineInputBorder(      
                      borderSide: BorderSide(color: Colors.white),  
                      ),  
                      ),
                    ),
                ),
                Container(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: note,
                      decoration: InputDecoration(
                        hintText: "Note",
                        enabledBorder: UnderlineInputBorder(      
                      borderSide: BorderSide(color: Colors.white),   
                      ),  
                      ),
                    ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: redColor,
                      child: Text("Cancel", style: whiteButtonTitle,),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    RaisedButton(
                      color: redColor,
                      child: Text("Add", style: whiteButtonTitle,),
                      onPressed: () {
                        if (taskName.text != null) {
                          addTask(taskName.text, note.text);
                          build(context);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

void addTask(String taskName, String note) async{
  databaseReference.once().then((DataSnapshot snapshot) {
    if(snapshot.value==null)
    databaseReference.child("1").set({
    'title': '$taskName',
    'completed' : false,
    'taskid' : '1',
    'note': '$note'
  });
  else
    databaseReference.child("${snapshot.value.length}").set({
    'title': '$taskName',
    'completed' : false,
    'taskid' : '${snapshot.value.length}',
    'note': '$note'
  });
  });
}
}
