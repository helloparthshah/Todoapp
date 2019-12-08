import 'package:todo/models/globals.dart';
import 'package:todo/models/widgets/intray_todo_widget.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/classes/task.dart';
import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.reference();
List<Task> taskList= [];

class IntrayPage extends StatefulWidget {
  @override
  _IntrayPageState createState() => _IntrayPageState();
}

class _IntrayPageState extends State<IntrayPage> {
  @override
  void initState(){
    super.initState();
    getList();
    build(context);
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    getList();
    /* setState(() {
      return Container(
      color: darkGreyColor,
      child: _buildReorderable(context)
      );
    }); */
    return Container(
      color: Colors.orange,
      child: _buildReorderable(context)
    );
  }

  Widget _buildListTile(BuildContext context,Task item){
    return Dismissible(
      key: Key(item.taskid),
      onDismissed: (direction){
        setState(() {
          taskList.removeAt(int.parse(item.taskid)-2);
          print((taskList.length+1).toString());
          databaseReference.child((taskList.length+1).toString()).remove();
          readdTask();
          getList();
          build(context);
        });
        Scaffold
        .of(context)
        .showSnackBar(SnackBar(content: Text("${item.title} dismissed")));
      },
    child:ListTile(
      // key: Key(item.taskid),
      title: new IntrayTodo(title: item.title,note: item.note,),
    )
    );
  }

  Widget _buildReorderable(BuildContext context){
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
                readdTask();
                getList();
                build(context);
          });
        },
      ),
    );
  }

Future readdTask() async{
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
getList();
}

Future getList() async{
  databaseReference.once().then((DataSnapshot snapshot) {
    taskList.clear();
    for(int i=1;i<snapshot.value.length;i++){
    taskList.add(Task(snapshot.value[i]['title'].toString(),snapshot.value[i]['completed'],"${i+1}",snapshot.value[i]['note'].toString()));
    // print(snapshot.value[i]);
    }
  });
  /* return taskList; */
}
}
