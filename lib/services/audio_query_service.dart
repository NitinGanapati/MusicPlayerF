import 'package:on_audio_query/on_audio_query.dart';

class AudioQueryService {
  final OnAudioQuery _audioQuery = new OnAudioQuery();

  Future<bool> isPermitted() async{
    bool permission = await _audioQuery.permissionsStatus();
    if(!permission){  permission = await _audioQuery.permissionsRequest(); }
    return permission;
  }

  Future<List<SongModel>> getSongs() async{
    bool permission = await isPermitted();
    if(!permission) return [];
    return await _audioQuery.querySongs(sortType: SongSortType.TITLE
    ,orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true
    );
  }
}