import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:date_time_picker/date_time_picker.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController todo_title = TextEditingController();
  TextEditingController todo_detail = TextEditingController();
  var date = "";

  @override
  Future postTodo() async {
    var url = Uri.http('10.0.2.2:8000', '/api/post-todolist');
    Map<String, String> header = {"Content-type": "application/json"};
    String jsondata =
        '{"title":"${todo_title.text}", "detail":"${todo_detail.text}", "date":"${date}"}';
    var response = await http.post(url, headers: header, body: jsondata);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // ช่องกรอกชื่อ To Do
            const SizedBox(height: 20),
            TextField(
                controller: todo_title,
                decoration: const InputDecoration(
                    labelText: 'To do', border: OutlineInputBorder())),
            const SizedBox(
              height: 30,
            ),

            // ช่องกรอกรายละเอียด
            TextField(
                minLines: 4,
                maxLines: 8,
                controller: todo_detail,
                decoration: const InputDecoration(
                    labelText: 'Detail', border: OutlineInputBorder())),
            const SizedBox(
              height: 30,
            ),

            DateTimePicker(
              initialValue: '',
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              dateLabelText: 'Date',
              onChanged: (val) {
                setState(() {
                  date = val.toString();
                });
              },
            ),

            // ปุ่มเพิ่มข้อมูล
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextButton.icon(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  postTodo();
                  //เคลียร์ข้อมูลหลังจากโพสต์
                  setState(() {
                    todo_title.clear();
                    todo_detail.clear();
                  });
                },
                label: const Text("Add", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.fromLTRB(50, 20, 50, 20)),
                    textStyle: MaterialStateProperty.all(
                        const TextStyle(fontSize: 30))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
