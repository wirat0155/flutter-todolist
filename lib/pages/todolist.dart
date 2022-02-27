import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add.dart';
import 'update.dart';
import 'dart:async';
import 'dart:convert';

class Todolist extends StatefulWidget {
  const Todolist({Key? key}) : super(key: key);

  @override
  _TodolistState createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  List _items = [];
  List _today_tasks = [];
  List _overdue_tasks = [];
  List _tomorrow_tasks = [];
  List _future_tasks = [];
  var has_overdue_task = "";
  var has_today_task = "";
  var has_tomorrow_task = "";
  var has_future_task = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    final response =
        await http.get(Uri.parse("http://10.0.2.2:8000/api/all-todolist/"));

    if (response.statusCode == 200) {
      var data = utf8.decode(response.bodyBytes);
      setData(jsonDecode(data));
    } else {
      throw Exception('Failed to load data');
    }
  }

  void setData(data) {
    setState(() {
      _items = data;
    });

    setTodayTask();
  }

  int diffDay(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  void setTodayTask() {
    _today_tasks = [];
    _overdue_tasks = [];
    _tomorrow_tasks = [];
    _future_tasks = [];

    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);

    // var i = 0;
    for (var i = 0; i < _items.length; i++) {
      var _item_year = int.parse(_items[i]["date"].substring(0, 4));
      var _item_month = int.parse(_items[i]["date"].substring(5, 7));
      var _item_date = int.parse(_items[i]["date"].substring(8, 10));

      DateTime _item_full_date =
          new DateTime(_item_year, _item_month, _item_date);
      var diffDay = this.diffDay(date, _item_full_date);

      // งานที่เกินกำหนด
      if (diffDay < 0) {
        setState(() {
          _overdue_tasks.add(_items[i]);
        });
      }
      // งานวันนี้
      else if (diffDay == 0) {
        setState(() {
          _today_tasks.add(_items[i]);
        });
      }
      // งานพรุ่งนี้
      else if (diffDay == 1) {
        setState(() {
          _tomorrow_tasks.add(_items[i]);
        });
      }
      // งานในอนาคต (เกินวันพรุ่งนี้ไปแล้ว)
      else if (diffDay > 1) {
        setState(() {
          _future_tasks.add(_items[i]);
        });
      }
    }

    setState(() {
      has_overdue_task = checkTaskNumber(_overdue_tasks);
    });
    setState(() {
      has_today_task = checkTaskNumber(_today_tasks);
    });
    setState(() {
      has_tomorrow_task = checkTaskNumber(_tomorrow_tasks);
    });
    setState(() {
      has_future_task = checkTaskNumber(_future_tasks);
    });
  }

  String checkTaskNumber(task) {
    if (task.length == 0) {
      return "No task";
    } else {
      return "";
    }
  }

  String convertDate(date) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    var year = date.substring(0, 4);
    var month = int.parse(date.substring(5, 7));
    var dateStr = date.substring(8, 10);

    return dateStr + " " + months[month - 1] + " " + year;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Text("Overdue", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
            Center(child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(has_overdue_task, style: TextStyle(fontSize: 16, color: Colors.grey[600]),),
            )),
            ListView.builder(
                shrinkWrap: true,
                itemCount: _overdue_tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    leading: const FlutterLogo(),
                    title: Text(_overdue_tasks[index]["title"]),
                    subtitle:
                        Text(convertDate(_overdue_tasks[index]["date"])),
                    trailing: const Icon(Icons.more_vert),
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdatePage(
                                      _overdue_tasks[index]["id"],
                                      _overdue_tasks[index]["title"],
                                      _overdue_tasks[index]["detail"],
                                      _overdue_tasks[index]["date"])))
                          .then((context) {
                        setState(() {
                          getData();
                        });
                      });
                    },
                  ));
                }),
            const Text("Today", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
            Center(child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(has_today_task, style: TextStyle(fontSize: 16, color: Colors.grey[600]),),
            )),
            ListView.builder(
                shrinkWrap: true,
                itemCount: _today_tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    leading: const FlutterLogo(),
                    title: Text(_today_tasks[index]["title"]),
                    subtitle: Text(convertDate(_today_tasks[index]["date"])),
                    trailing: const Icon(Icons.more_vert),
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdatePage(
                                      _today_tasks[index]["id"],
                                      _today_tasks[index]["title"],
                                      _today_tasks[index]["detail"],
                                      _today_tasks[index]["date"])))
                          .then((context) {
                        setState(() {
                          getData();
                        });
                      });
                    },
                  ));
                }),
            const Text("Tomorrow", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
            Center(child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(has_tomorrow_task, style: TextStyle(fontSize: 16, color: Colors.grey[600]),),
            )),
            ListView.builder(
                shrinkWrap: true,
                itemCount: _tomorrow_tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    leading: const FlutterLogo(),
                    title: Text(_tomorrow_tasks[index]["title"]),
                    subtitle:
                        Text(convertDate(_tomorrow_tasks[index]["date"])),
                    trailing: const Icon(Icons.more_vert),
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdatePage(
                                      _tomorrow_tasks[index]["id"],
                                      _tomorrow_tasks[index]["title"],
                                      _tomorrow_tasks[index]["detail"],
                                      _tomorrow_tasks[index]["date"])))
                          .then((context) {
                        setState(() {
                          getData();
                        });
                      });
                    },
                  ));
                }),
            const Text("Later", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
            Center(child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(has_future_task, style: TextStyle(fontSize: 16, color: Colors.grey[600]),),
            )),
            ListView.builder(
                shrinkWrap: true,
                itemCount: _future_tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    leading: const FlutterLogo(),
                    title: Text(_future_tasks[index]["title"]),
                    subtitle: Text(convertDate(_future_tasks[index]["date"])),
                    trailing: const Icon(Icons.more_vert),
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdatePage(
                                      _future_tasks[index]["id"],
                                      _future_tasks[index]["title"],
                                      _future_tasks[index]["detail"],
                                      _future_tasks[index]["date"])))
                          .then((context) {
                        setState(() {
                          getData();
                        });
                      });
                    },
                  ));
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddPage()))
              .then((context) {
            setState(() {
              getData();
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
