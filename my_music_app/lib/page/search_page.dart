import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_music_app/core/convert.dart';
import 'package:my_music_app/core/search_song.dart';
import 'package:my_music_app/data/track_library.dart';
import 'package:my_music_app/features/media_player/bloc/media_player_cubit.dart';
import 'package:my_music_app/model/service/song_service.dart';
import 'package:my_music_app/model/song.dart';
import 'package:my_music_app/widgets/add_song_to_playList.dart';

import '../injection_container.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static List<Song> song = [];
  List<Song> temp = [];
  @override
  void initState() {
    super.initState();
    initSong();
  }

  initSong() async {
    song = await SongService().getAllSong();
    print("day la song load dươc khi tìm kiếm: ${song.length}");
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: serviceLocator<MediaPlayerCubit>()),
      ],
      child: BlocBuilder<MediaPlayerCubit, MediaPlayerStateAbstract>(
          builder: (context, mediaPlayerState) {
        return Container(
          height: double.infinity,
          // color: Colors.green,
          child: Column(children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Tìm theo tên bài hát, ca sĩ",
                  prefixIcon: Icon(Icons.search),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    temp = findByName(value, song);
                    print("day la song load dươc temp: ${temp.length}");
                    for(int i=0; i<temp.length; i++){
                      print(temp[i].name);
                    }
                  });
                },
              ),
            ),
            Expanded(
              // color: Colors.blue,
              // height: 500,
              child: ListView.builder(
                itemCount: temp.length,
                itemBuilder: (context, index) {
                  return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      secondaryActions: [
                        IconSlideAction(
                          caption: 'Playlist',
                          color: Colors.blue,
                          icon: Icons.playlist_add,
                          onTap: () {
                            addSongToPlaylist(context, temp[index].id);
                          },
                        ),
                      ],
                      child: ListTile(
                          title: Text(temp[index].name),
                          subtitle: Text(temp[index].singer),
                          onTap: () async {
                            List<Song> songs = await SongService()
                                .getSong(20, int.parse(temp[index].id));

                            BlocProvider.of<MediaPlayerCubit>(context)
                                .stopFromIsolate();
                            print('pause tap');
                            TrackLibrary.playList = {};

                            TrackLibrary.playList =
                                convertSongToTrack(songs, 0);

                            TrackLibrary.playList.forEach((key, value) {
                              print("$key, ${value.title}");
                            });

                            BlocProvider.of<MediaPlayerCubit>(context).play();
                            print("tap play");
                            SongService().updateFigure(songs[index].id);
                          }));
                },
              ),
            ),
          ]),
        );
      }),
    );
  }
}
