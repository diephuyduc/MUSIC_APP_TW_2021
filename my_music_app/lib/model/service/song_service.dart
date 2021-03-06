import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_music_app/comon_variable.dart';

import 'package:my_music_app/model/singer.dart';
import 'package:my_music_app/model/song.dart';

class SongService {
  static final ref = FirebaseFirestore.instance.collection("song_data");
  getASong(String id) async {
    Song temp;

    await ref.where('id', isEqualTo: id).get().then((value) {
      value.docs.forEach((element) async {
        temp = Song.fromJson(element.data());
      });
    });
    final reft = FirebaseStorage.instance.ref().child("${temp.id}.mp3");
    await reft.getDownloadURL().then((value) {
      temp.path = value;
    });
    return temp;
  }

  Future<List<Song>> getSong(int limit, int idNow) async {
    List<Song> temp = [];
    print("day la danh sach $idNow");
    await ref
        .where('id', isGreaterThanOrEqualTo: idNow.toString())
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element.data().toString());
        Song tempSong = Song.fromJson(element.data());
        temp.add(tempSong);
      });
    });
    for (int i = 0; i < temp.length; i++) {
      final ref = FirebaseStorage.instance.ref().child("${temp[i].id}.mp3");
      await ref.getDownloadURL().then((value) {
        temp[i].path = value;
      });
    }

    print(temp.length);
    return temp;
  }

  getAlbumName() async {
    List<String> album = [];

    await ref.get().then((value) {
      value.docs.forEach((element) {
        if (!album.contains(element['album'])) {
          album.add(element['album']);
        }
      });
    });

    return album;
  }

  getSongInAlbum(String albumName) async {
    List<Song> songs = [];

    await ref.where('album', isEqualTo: albumName).get().then((value) {
      value.docs.forEach((element) {
        songs.add(Song.fromJson(element.data()));
      });
    });
    for (int i = 0; i < songs.length; i++) {
      final ref = FirebaseStorage.instance.ref().child("${songs[i].id}.mp3");
      await ref.getDownloadURL().then((value) {
        songs[i].path = value;
      });
    }
    return songs;
  }

  getSingerName() async {
    List<String> singer = [];
    await ref.get().then((value) {
      value.docs.forEach((element) {
        if (!singer.contains(element.data()['singer']) &&
            element.data()['singer'] != null) {
          singer.add(element.data()['singer']);
          // print("${element.data()['singer']}");
        }
      });
    });

    List<Singer> sing = [];
    String path;
    await Future.wait(List.generate(singer.length, (index) async {
      return await ref
          .where('singer', isEqualTo: singer[index])
          .limit(1)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          path = element.data()["artImage"];
          if (path == null || path == "") {
            path = defaultImage;
          }
          sing.add(Singer(name: singer[index], img: path));
        });
      });
    }));
    print(sing.length);
    return sing;
  }

  getGenrderName() async {
    List<String> genderName = [];
    await ref.get().then((value) {
      value.docs.forEach((element) {
        if (!genderName.contains(element.data()['gender']) &&
            element.data()['gender'] != null) {
          genderName.add(element.data()['gender']);
        }
      });
    });

    return genderName;
  }

  getArtImageForSinger(String singer) async {
    await ref.where('singer', isEqualTo: singer).limit(1).get().then((value) {
      value.docs.forEach((element) {
        return element.data()["artImage"];
      });
    });
  }

  getSongInSinger(String singer) async {
    List<Song> songs = [];

    await ref.where('singer', isEqualTo: singer).get().then((value) {
      value.docs.forEach((element) {
        songs.add(Song.fromJson(element.data()));
      });
    });
    for (int i = 0; i < songs.length; i++) {
      final ref = FirebaseStorage.instance.ref().child("${songs[i].id}.mp3");
      await ref.getDownloadURL().then((value) {
        songs[i].path = value;
      });
    }
    return songs;
  }

  Future<List<Song>> getSongInGender(String gender) async {
    List<Song> songs = [];

    await ref.where('gender', isEqualTo: gender).get().then((value) {
      value.docs.forEach((element) {
        songs.add(Song.fromJson(element.data()));
      });
    });
    for (int i = 0; i < songs.length; i++) {
      final ref = FirebaseStorage.instance.ref().child("${songs[i].id}.mp3");
      await ref.getDownloadURL().then((value) {
        songs[i].path = value;
      });
    }
    return songs;
  }

  Future<List<Song>> getTopSong() async {
    List<Song> temp = [];
    await ref
        .limit(10)
        .orderBy("figure", descending: true)
        .get()
        .then((value) async {
      value.docs.forEach((element) async {
        // print(element.data());

        Song tempSong = Song.fromJson(element.data());
        if (tempSong.artImage == "" || tempSong.artImage == null) {
          tempSong.artImage = defaultImage;
        }
        temp.add(tempSong);
      });
      // print(path);
      // String path =
      //     await StoragePath().getUrl((element.data()['id'].toString()));
      // tempSong.path = path;
    });
    Future.wait(List.generate(temp.length, (index) {
      var reff = FirebaseStorage.instance.ref().child("${temp[index].id}.mp3");
      return reff.getDownloadURL().then((value) {
        temp[index].path = value;
      });
    }));
    return temp;
  }

  Future<List<Song>> getNewSong() async {
    List<Song> temp = [];
    await ref
        .orderBy("upload_date", descending: true)
        .limit(10)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        Song tempSong = Song.fromJson(element.data());
        if (tempSong.artImage == "" || tempSong.artImage == null) {
          tempSong.artImage = defaultImage;
        }
        temp.add(tempSong);
      });
    });
    await Future.wait(List.generate(temp.length, (index) {
      var reff = FirebaseStorage.instance.ref().child("${temp[index].id}.mp3");
      return reff.getDownloadURL().then((value) {
        temp[index].path = value;
      });
    }));

    return temp;
  }

  chartSong() async {
    List<Song> newSong = [];
    await getNewSong().then((value) => newSong = value);
    print(newSong.length);
    newSong.sort((a, b) => b.figure.compareTo(a.figure));

    return newSong;
  }

  updateFigure(String id) async {
    String figure;
    await ref.where('id', isEqualTo: id).get().then((value) {
      figure = (value.docs[0].data()['figure']).toString();
    });
    await ref
        .doc(id)
        .set({'figure': (int.parse(figure) + 1)}, SetOptions(merge: true)).then(
            (value) {
      print("da tang luot nghe");
    });
  }

  getAllSong() async {
    List<Song> temp = [];
    await ref.get().then((value) {
      value.docs.forEach((element) {
        Song tempSong = Song.fromJson(element.data());
        if (tempSong.artImage == "" || tempSong.artImage == null) {
          tempSong.artImage = defaultImage;
        }
        temp.add(tempSong);
      });
    });
    await Future.wait(List.generate(temp.length, (index) {
      var reff = FirebaseStorage.instance.ref().child("${temp[index].id}.mp3");
      return reff.getDownloadURL().then((value) {
        temp[index].path = value;
      });
    }));
    return temp;
  }
}
