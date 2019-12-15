import 'package:todo/models/widgets/intray_todo_widget.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/classes/task.dart';
import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.reference();
var taskList = new List<Task>();

class Test extends StatefulWidget {
  @override
  _TestState createState() => new _TestState();
}

class _TestState extends State<Test> {

  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Center(
              child: new CircularProgressIndicator(),
            );
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
              else if(taskList.length==0)
              {
                return new Center(
                  child: new CircularProgressIndicator(),
                );
              }
            else{
              getList();
              return createListView(context, snapshot);
            }
        }
      },
    );

    return new Scaffold(
      backgroundColor: Colors.black,
      body: futureBuilder,
    );
  }

void readdTask(){
  for(int i=1;i<=taskList.length;i++){
  databaseReference.once().then((DataSnapshot snapshot) {
    databaseReference.child("$i").set({
    'title': '${taskList[i-1].title}',
    'completed' : false,
    'taskid' : '$i',
    'note': '${taskList[i-1].note}'
  });
  });
}
}

  void getList() {
  databaseReference.once().then((DataSnapshot snapshot) {
    taskList.clear();
    for(int i=1;i<snapshot.value.length;i++){
    taskList.add(Task(snapshot.value[i]['title'].toString(),snapshot.value[i]['completed'],"${i+1}",snapshot.value[i]['note'].toString()));
    // print(snapshot.value[i]);
    }
  });
}

  Future<List<Task>> _getData() async {
    getList();
    await new Future.delayed(new Duration(seconds: 0));
    return taskList;
  }

Widget _buildListTile(BuildContext context,Task item){
    /* return Dismissible(
      key: Key(item.taskid),
      onDismissed: (direction){
        setState(() {
          taskList.removeAt(int.parse(item.taskid)-1);
          readdTask();
          getList();
          databaseReference.child((taskList.length).toString()).remove();
          getList();
        });
        Scaffold
        .of(context)
        .showSnackBar(SnackBar(content: Text("${item.title} dismissed")));
      }, */
    return ListTile(
      key: Key(item.taskid),
      title: new IntrayTodo(title: item.title,note: item.note,),
    );
    /* ); */
  }

Widget _buildReorderable(BuildContext context) {
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: ReorderableListView(
        padding: EdgeInsets.only(top: 300.0),
        children: taskList.map((Task item) => _buildListTile(context, item)).toList(),
        onReorder: (oldIndex,newIndex){
          setState(() {
            if(newIndex>oldIndex){
              newIndex-=1;
            }
                Task item =taskList[oldIndex];
                taskList.remove(item);
                taskList.insert(newIndex, item);
          });
          readdTask();
          build(context);
          /* readdTask();
          getList(); */
        },
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    return  _buildReorderable(context);
  }
}