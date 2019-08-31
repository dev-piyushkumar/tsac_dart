# tsac_dart

Asynchronous task management tool for dart.

## Getting Started
To use this plugin, add `tsac_dart` as a dependency in your pubspec.yaml file.

### Example

``` dart
import 'package:tsac_dart/tsac_dart.dart';

main() {

  tsac.startTask(task1);

  tsac.startTask(task2);
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
```

## New Updates

This project is under construction so if you find any issues, 
please add it on issue tracker [here](https://github.com/dev-piyushkumar/tsac_dart/issues).
![](https://media1.tenor.com/images/c389830a55d9166b648f16996214ef57/tenor.gif)