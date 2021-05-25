import 'package:my_music_app/data/track_library.dart';
import 'package:my_music_app/features/audio_track/data/model/audio_track_model.dart';
import 'package:my_music_app/features/audio_track/domain/entities/audio_track.dart';
import 'package:my_music_app/features/audio_track/domain/repositories/audio_track_repository_abstract.dart';

class AudioTrackRepository extends AudioTrackRepositoryAbstract {
  @override
  Future<AudioTrack> next({int currentTrackIndex}) async {
    var library = TrackLibrary.playList;
    print('ddd');
    print(library.toString());
    final nextTrackIndex =
        currentTrackIndex == null ? 0 : currentTrackIndex + 1;

    if (nextTrackIndex >= library.length) {
      return null;
    }

    var nextTrack = TrackLibrary.playList[nextTrackIndex];

    return AudioTrackModel(nextTrack.url, nextTrack.author, nextTrack.title,
        nextTrackIndex, nextTrack.id);
  }

  @override
  Future<AudioTrack> previous(int currentTrackIndex) async {
    final prevTrackIndex = currentTrackIndex - 1;

    if (prevTrackIndex < 0) {
      return null;
    }

    var prevTrack = TrackLibrary.playList[prevTrackIndex];

    return AudioTrackModel(prevTrack.url, prevTrack.author, prevTrack.title,
        prevTrackIndex, prevTrack.id);
  }
}
