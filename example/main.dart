import 'package:tsac_dart/tsac_dart.dart';

main() {

  tsac.startTask(task1);

  tsac.startTask(task2);
}

final Task task1 = Task(token: "12345", jobs: [
  () async {
    print("task1.job1 started!");
    await Future.delayed(Duration(seconds: 3));
    print("task1.job1 done!");
  },
  () async {
    print("task1.job2 started!");
    await Future.delayed(Duration(seconds: 3));
    print("task1.job2 done!");
  },
],);

final Task task2 = Task(token: "123456", jobs: [
  () async {
    print("task2.job1 started!");
    tsac.cancelWithToken("12345");
    await Future.delayed(Duration(milliseconds: 700));
    print("task2.job1 done!");
  },
  () async {
    print("task2.job2 started!");
    await Future.delayed(Duration(milliseconds: 1200));
    print("task2.job2 done!");
  },
],);