import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    MaterialApp(
      // debugShowCheckedModeBanner: false,
      home: new HomePage(),
      title: "ePerpus",
      routes: {
        '/home': (BuildContext context) => HomePage(),
        '/absensi': (BuildContext context) => AbsensiPage(),
        '/peminjaman': (BuildContext context) => PeminjamanPage(),
      },
    )
  );
}

mainDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'ePerpus',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Alfian Dwi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '<viandwicyber@gmail.com>',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  )
                ],
              )
            ],
          )
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () => Navigator.pushReplacementNamed(context, '/home')
        ),
        ListTile(
          leading: Icon(Icons.calendar_today),
          title: Text('Log Absensi'),
          onTap: () => Navigator.pushReplacementNamed(context, '/absensi')
        ),
        ListTile(
          leading: Icon(Icons.book),
          title: Text('Log Peminjaman'),
          onTap: () => Navigator.pushReplacementNamed(context, '/peminjaman')
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('ePerpus')
      ),
      drawer: mainDrawer(context),
      body: Container(
        margin: EdgeInsets.all(10),
        child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.all(8),
            color: Colors.blue,
            child: Text(
              'Selamat datang di aplikasi ePerpus!',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class AbsensiPage extends StatefulWidget {
  static const String routeName = '/absensi';

  @override
  State<StatefulWidget> createState() => new AbsensiState();
}

class AbsensiState extends State<AbsensiPage> {
  List<dynamic> _listAbsensi = [];

  Future<bool> getData() async {
    http.Response response = await http.get(
      Uri.encodeFull('http://629ad138f4f3.ngrok.io/api.php?action=absensi&id=2'),
      headers: {
        'Accept': 'Application/json'
      }
    );
    dynamic result = jsonDecode(response.body);

    setState(() {
      _listAbsensi = result;
    });

    print(_listAbsensi);
    return true;
  }

  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('ePerpus - Log Absensi')
      ),
      drawer: mainDrawer(context),
      body: (_listAbsensi == null || _listAbsensi.length == 0)
          ? Center(child: Text('Loading data...'))
          : new ListView.builder(
              itemCount: _listAbsensi == null ? 0 : _listAbsensi.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.timer),
                    title: Text(_listAbsensi[index]['waktu'])
                  ),
                );
              }
            )
    );
  }
}



class PeminjamanPage extends StatefulWidget {
  static const String routeName = '/peminjaman';

  @override
  State<StatefulWidget> createState() => new PeminjamanState();
}

class PeminjamanState extends State<PeminjamanPage> {
  List<dynamic> _listPeminjaman = [];

  Future<bool> getData() async {
    http.Response response = await http.get(
      Uri.encodeFull('http://629ad138f4f3.ngrok.io/api.php?action=peminjaman&id=1'),
      headers: {
        'Accept': 'Application/json'
      }
    );
    dynamic result = jsonDecode(response.body)['data'];

    setState(() {
      _listPeminjaman = result;
    });

    print(_listPeminjaman);
    return true;
  }

  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('ePerpus - Log Peminjaman')
      ),
      drawer: mainDrawer(context),
      body: (_listPeminjaman == null || _listPeminjaman.length == 0)
          ? Center(child: Text('Loading data...'))
          : new ListView.builder(
              itemCount: _listPeminjaman == null ? 0 : _listPeminjaman.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    // leading: Icon(Icons.book),
                    title: Text(_listPeminjaman[index]['buku_judul']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Status : ' + _listPeminjaman[index]['status']),
                        Text('Pinjam : ' + _listPeminjaman[index]['tanggal_pinjam']),
                        Text('Kembali : ' + _listPeminjaman[index]['tanggal_kembali']),
                      ],
                    ),
                  ),
                );
              }
            )
    );
  }
}