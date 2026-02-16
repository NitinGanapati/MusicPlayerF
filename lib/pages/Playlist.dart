import 'package:flutter/material.dart';

class Playlist extends StatefulWidget {
  const Playlist({super.key});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  final List<String> items = ["a","b","c","ks","sf","asd","km","sd","er","aa","se"];
    Widget build(BuildContext context){
      return Scaffold(
        appBar: AppBar(title: Text('Playlists'),
        ),
        body:
            ListView.builder(
              itemCount:items.length,
              itemBuilder:(context,index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black45,width: 1.0),
                      borderRadius: BorderRadius.circular(1.5)
                    ),
                    leading: Icon(Icons.music_note,color: Colors.blue,),
                    title: Text(items[index]),
                    subtitle: Text(items[index]),
                    trailing: Icon(Icons.info),
                  ),
                );
              }
            ),
        );
    }
}