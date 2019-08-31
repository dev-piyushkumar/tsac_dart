import 'package:flutter_test/flutter_test.dart';

import 'package:tsac_dart/tsac_dart.dart';

void main() {
  test('tsac_dart simple test', () async {
    tsac.startTask(task1);
    tsac.startTask(task2);
    await Future.delayed(Duration(seconds: 4));
  });
}

final Task task1 = Task(token: "12345", jobs: [
      () async {
    print("task1.job1 started!");
    await Future.delayed(Duration(milliseconds: 700));
    print("task1.job1 done!");
  },
      () async {
    print("task1.job2 started!");
    await Future.delayed(Duration(milliseconds: 700));
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
    await Future.delayed(Duration(milliseconds: 700));
    print("task2.job2 done!");
  },
],);