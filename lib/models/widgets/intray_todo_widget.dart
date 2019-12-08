import 'package:todo/models/globals.dart';
import 'package:flutter/material.dart';

class IntrayTodo extends StatefulWidget{
  final String title;
  final String note;
  final String keyvalue;
  IntrayTodo({this.keyvalue, this.title,this.note});

  @override
  _IntrayTodoState createState() => _IntrayTodoState();
}

class _IntrayTodoState extends State<IntrayTodo> {
  bool checked=false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
        children: <Widget>[Container(
        key: Key(widget.keyvalue),
        margin: EdgeInsets.only(bottom: 5),
        padding: EdgeInsets.all(10),
        // height: 100,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: redColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            new BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10.0,
            )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            /* Radio(
              value: 1,
            ), */
            Checkbox(
              checkColor: darkGreyColor,
              activeColor: Colors.transparent,
              value: checked,
              onChanged: (bool newValue) {
                setState(() {
                  checked=newValue;
                });
              }
            ),
            Flexible(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.title, style:darkTodoTitle,textAlign: TextAlign.left,),
                Text(widget.note, style: darkNoteTitle,textAlign: TextAlign.left, maxLines: 5, overflow: TextOverflow.fade,),
              ],
             )
            )
        ],),
      ),
      ]
    );
  }
}