class Task{
  List<Task> tasks;
  String note;
  DateTime timeToComplete;
  bool completed;
  String repeats;
  DateTime deadline;
  List<DateTime> reminders;
  String taskid;
  String title;

  Task(this.title,this.completed,this.taskid,this.note);
}