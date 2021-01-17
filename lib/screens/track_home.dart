import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modulate_vsc/screens/module_home.dart';
import 'package:modulate_vsc/src/firebase/database.dart';

class TrackHome extends StatefulWidget {
  final String name;

  TrackHome({this.name});

  @override
  _TrackHomeState createState() => _TrackHomeState(name);
}

class _TrackHomeState extends State<TrackHome> {
  String name;
  List<dynamic> _moduleNames = [];
  List<dynamic> _moduleInfo = [];

  _TrackHomeState(String name){
    this.name = name;
    getData();
  }

  getData() async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    List<Object> result = await DatabaseService(uid).getTrack(name);
    if (result.isNotEmpty) {
      setState(() {
        _moduleNames = result[0];
        _moduleInfo = result[1];
      });
    }
  }

  Widget _buildView() {
    return ListView.builder(
        itemCount: _moduleNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_moduleNames[index]),
            subtitle: Text(_moduleInfo[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ModuleHome();
                  },
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: _buildView(),
    );
  }
}
