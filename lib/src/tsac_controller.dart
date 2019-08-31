import 'package:meta/meta.dart';
import 'types.dart';

class Task {

  final String token;
  final List<Job> _jobs;
  TsacFlag _status;

  Task({@required this.token, List<Job> jobs}): assert(token!=null),
  _jobs = (jobs!=null)?jobs.toList(growable: false):[], _status = TsacFlag.pending;

  String get id => (hashCode?.toString()??"null id!");

  int get jobCount {
    int result = 0;
    _jobs.forEach((job){
      if(job!=null)
        result += 1;
    });
    return result;
  }

  TsacFlag get status => (_status??TsacFlag.pending);

  @override
  String toString() {
    return "@Task:"+id+"["+_jobs.length.toString()+", job(s)]";
  }
}



class Tsac {

  final List<Task> _tasks = List();
  final List<String> _rejectionTokens = List();

  /// [task] is added to working list. As soon as [task] is added to working list,
  /// its jobs starts executing in the order of job list add to this [task].
  ///
  /// If the [task] is null then it is not added to the working list.
  /// If the [task] status is [TsacFlag.completed] or [TsacFlag.canceled] then,
  /// jobs will not execute.
  Task startTask(Task task){
    if(task==null) {
      print("Tsac: startTask(Task task) cannot accept null task!");
      return task;
    }
    if(task.jobCount>0) {
      _tasks.add(task);
      _executeTask(task);
    }
    return task;
  }

  /// adds a token to rejection list so as to stop further job execution.
  ///
  /// If the [token] is null then it is not added to rejection list.
  cancelWithToken(String token) {
    if(token==null) {
      print("Tsac: cancelWithToken(String token) cannot accept null tokens!");
      return;
    }
    if(!_rejectionTokens.contains(token))
      _rejectionTokens.add(token);
  }

  _executeTask(Task task) async {
    if(task==null || task._status==TsacFlag.canceled || task._status==TsacFlag.completed) {
      await _cleanUpCheck();
      return;
    }
    task._status = TsacFlag.working;
    for(int i=0; i< (task._jobs.length); i++) {
      if(_rejectionTokens.contains(task.token))
        task._status = TsacFlag.canceled;

      if(task._status==TsacFlag.canceled)
        break;

      final job = task._jobs[i];
      if(job!=null) {
        await job();
      }
    }
    if(task._status!= TsacFlag.canceled)
      task._status = TsacFlag.completed;

    await _cleanUpCheck();
  }


  _cleanUpCheck() {
    int i = _tasks.length - 1;
    while(i>-1) {
      final task = _tasks[i];
      if(task._status==TsacFlag.canceled || task.status==TsacFlag.completed) {
        _tasks.removeAt(i);
      }
      i--;
    }

    i = _rejectionTokens.length - 1;
    while(i>-1) {
      bool shouldRemove = true;
      String token = _rejectionTokens[i];
      for (int j=0; j<_tasks.length; j++) {
        final task = _tasks[j];
        if(task.token==token) {
          shouldRemove = false;
          break;
        }
      }

      if(shouldRemove) {
        _rejectionTokens.removeAt(i);
      }
      i--;
    }
  }

  Tsac._private();

  static final Tsac _instance = Tsac._private();
}


/// Singleton instance of [Tsac].
final Tsac tsac = Tsac._instance;