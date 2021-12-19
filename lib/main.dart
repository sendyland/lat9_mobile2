import 'package:flutter/material.dart';
import 'package:flutter_sqflite_sendy/sql_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter SQLite',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter SQLite'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController judulController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  @override
  void initState() {
    refreshCatatan();
    super.initState();
  }

  //ambil data dari database
  List<Map<String, dynamic>> catatan = [];
  void refreshCatatan() async {
    final data = await SQLHelper.getCatatan();
    setState(() {
      catatan = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(catatan);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: catatan.length,
          itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Text(catatan[index]['judul']),
                  subtitle: Text(catatan[index]['deskripsi']),
                ),
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modalForm();
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //fungsi tambah data
  Future<void> tambahCatatan() async {
    await SQLHelper.tambahCatatan(
        judulController.text, deskripsiController.text);
    refreshCatatan();
  }

  void modalForm() async {
    showModalBottomSheet(
        context: context,
        builder: (_) => Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            height: 800,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: judulController,
                    decoration: const InputDecoration(hintText: 'Nama'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: deskripsiController,
                    decoration: const InputDecoration(hintText: ' No Hape'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await tambahCatatan();
                      judulController.text = '';
                      deskripsiController.text = '';
                      Navigator.pop(context);
                    },
                    child: const Text('Tambah'),
                  )
                ],
              ),
            )));
  }
}
