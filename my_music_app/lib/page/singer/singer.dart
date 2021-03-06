import 'package:flutter/material.dart';
import 'package:my_music_app/core/search_album.dart';
import 'package:my_music_app/model/service/song_service.dart';

import 'package:my_music_app/model/singer.dart';
import 'package:my_music_app/page/singer/singer_detail.dart';

class SingerPage extends StatefulWidget {
  @override
  _SingerPageState createState() => _SingerPageState();
}

class _SingerPageState extends State<SingerPage> {
  List<Singer> singerName = [];
  List<Singer> temp = [];
  String word;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Ca sĩ",
            style: TextStyle(color: Colors.blue),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Tìm theo tên ca sĩ",
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
                    word = value;
                  });
                },
              ),
            ),
            Expanded(
              // height: MediaQuery.of(context).size.height,
              // width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                  future: SongService().getSingerName(),
                  builder: (context, snapshot) {
                    print(snapshot.data.toString());
                    if (snapshot.hasData) {
                      temp = snapshot.data;
                      singerName = findSinger(word, temp);
                      return ListView.builder(
                        itemCount: singerName.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Container(
                                width: 50,
                                height: 50,
                                child: Image.network(
                                  singerName[index].img,
                                  fit: BoxFit.cover,
                                )),
                            title: Text(singerName[index].name),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SingerDetail(
                                      singer: singerName[index],
                                    ),
                                  ));
                            },
                          );
                        },
                      );
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),

              // Positioned(
              //   child: MiniBar(),
              //   bottom: 0,
              //   right: 0,
              //   left: 0,
              // ),
            ),
          ]),
        ),
      ),
    );
  }
}
