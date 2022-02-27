import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker/date_time_picker.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage(this.id, this.title, this.detail, this.date);
  final id, title, detail, date;

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  var _id, _title, _detail, _date;
  TextEditingController todo_title = TextEditingController();
  TextEditingController todo_detail = TextEditingController();
  var date = "";

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _title = widget.title;
    _detail = widget.detail;
    _date = widget.date;
    todo_title.text = _title;
    todo_detail.text = _detail;
  }

  Future updateTodo() async {
    var url = Uri.http('10.0.2.2:8000', '/api/update-todolist/$_id');
    Map<String, String> header = {"Content-type": "application/json"};
    String jsondata =
        '{"title":"${todo_title.text}", "detail":"${todo_detail.text}", "date":"${_date}"}';
    var response = await http.put(url, headers: header, body: jsondata);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Task"), actions: [
        IconButton(
            onPressed: () {
              _showMyDialog(context, _id);
            },
            icon: const Icon(
              Icons.delete,
            ))
      ]),
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
                labelText: 'Detail', border: OutlineInputBorder()
              )
            ),
            const SizedBox(
              height: 30,
            ),

            DateTimePicker(
              initialValue: _date,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              dateLabelText: 'Date',
              onChanged: (val) {
                print(val.toString());
                setState(() {
                  _date = val.toString();
                });
              },
            ),

            // ปุ่มเพิ่มข้อมูล
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextButton.icon(
                icon: const Icon(Icons.mode_edit, color: Colors.white),
                onPressed: () {
                  updateTodo().then((value) => Navigator.pop(context));
                },
                label: const Text("Edit", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange),
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

Future<void> _showMyDialog(context, _id) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm to Delete ?'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Text('Do you really want to delete this todo? This process cannot be undone'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Confirm', style: const TextStyle(color: Colors.white)),
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
            onPressed: () {
              print("Delete ID $_id");
              deleteTodo(_id).then((value) => Navigator.pop(context));
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Cancel', style: const TextStyle(color: Colors.white)),
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


Future deleteTodo(_id) async {
    var url = Uri.http('10.0.2.2:8000', '/api/delete-todolist/$_id');
    Map<String, String> header = {"Content-type": "application/json"};
    var response = await http.delete(url, headers: header);
  }