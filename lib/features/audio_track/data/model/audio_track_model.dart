import 'package:my_music_app/features/audio_track/domain/entities/audio_track.dart';

class AudioTrackModel extends AudioTrack {
  AudioTrackModel(
      String url, String author, String title, int currentTrackIndex, String id)
      : super(url, author, title, currentTrackIndex, id);
}
