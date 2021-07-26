import 'package:flutter/material.dart';
import 'package:my_music_app/core/convert.dart';
import 'package:my_music_app/model/service/playlist_service.dart';
import 'package:my_music_app/widgets/add_new_playlist.dart';

addSongToPlaylist(BuildContext context, String id) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Container(
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  addNewPlaylist(context);
                },
                child: Text("Tạo mới"),
              ),
              Container(
                alignment: Alignment.center,
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.height * 0.5,
                child: StreamBuilder(
                  stream: PlaylistService().getMyPlaylist(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Map result = snapshot.data.data();
                      print(result.toString());
                      if(result != null){

                       List<String> name =
                          convertStringPlayListToName(result.keys.toString());
                      return ListView.builder(
                        itemCount: name.length,
                        itemBuilder: (context, index) {
                          return Material(
                            child: ListTile(
                                title: Text(name[index]),
                                onTap: () {
                                  PlaylistService()
                                      .addASongToPlaylist(id, name[index]);
                                  Navigator.pop(context);
                                }),
                          );
                        },
                      );
                    }
                     else {
                      return Container();
                    }
                    }
                    
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
