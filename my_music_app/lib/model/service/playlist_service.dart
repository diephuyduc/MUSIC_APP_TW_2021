import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlaylistService {
  static final ref = FirebaseFirestore.instance.collection("user_play_list");
  Stream<DocumentSnapshot> getMyPlaylist() {
    String email = FirebaseAuth.instance.currentUser.email;
    var result = ref.doc(email).snapshots();
     print("ddaa");
    print(result);
    return result;
  }

  getAllSongOfAPlaylist(String playListName) async {
    List<dynamic> list = [];
    String email = FirebaseAuth.instance.currentUser.email;
    await ref.doc(email).get().then((value) {
      list = value.data()[playListName];
    });
    return list;
  }

  createNewPLayList(String name, List<dynamic> listValue) async {
    String emailCurrent = FirebaseAuth.instance.currentUser.email;
    await ref
        .doc(emailCurrent)
        .set({name: listValue}, SetOptions(merge: true)).then((value) {
      print("them thanh cong");
    });
  }

  deleteAPlaylist(String name) async {
    String emailCurrent = FirebaseAuth.instance.currentUser.email;
    await ref.doc(emailCurrent).update({name: FieldValue.delete()});
  }

  deleteASongFromPlayList(String idSong, String playListName) async {
    List<dynamic> org = await getAllSongOfAPlaylist(playListName);
    org.remove(idSong);
    await deleteAPlaylist(playListName);
    await createNewPLayList(playListName, org);
  }

  addASongToPlaylist(String idSong, String playListName) async {
    List<dynamic> org = await getAllSongOfAPlaylist(playListName);
    org.add(idSong);
    await deleteAPlaylist(playListName);
    await createNewPLayList(playListName, org);
  }
}
