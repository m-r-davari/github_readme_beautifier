import 'dart:typed_data';
import 'package:ffmpeg_wasm/ffmpeg_wasm.dart';
import 'package:github_readme_beautifier/core/gif_maker/i_gif_maker.dart';

class GifMaker extends IGifMaker {

  final FFmpeg _fFmpeg;
  GifMaker(this._fFmpeg);

  @override
  Future<Uint8List> createGif(
      {required List<Uint8List> frames, String frameRate = '50', String exportRate = '20', required String fileName,
      String loopNum = '0', String maxColors = '200', String exportFileName = 'output', bool loopDelay = false}) async {

    //frame rate changes from 24 to 50
    //because with reverse frames we have total 50 frames and if we want to use 24 fps export it will deduct frames and cause the
    //non equal start and end frame of our frame list when we set the frame rate to 50 , in export the start and end frame wil
    //the same, but it will increase the gif size, we could make lower frame rate on frames for generator to make sure both
    // forward and reverse frames to gether will be around 50 frames so we need to have around 12 org frames and then
    // with 12 reverse frames the total frames will be 24 and ir will fix the gif size but may have effect on animation smoothness

    //another idea for make start and end frame equals is to make two gif, first with 24 frames and then
    //make the created gif reversed, and then concat two gif to each other,
    // below is the sample code for this idea, it should be test
    // '-r' is the frame rate of export it must be 24 and it effects the size of export gif higher -r will cause higher size.
    // best -r values is between 20~24.


    for (int i = 0; i < frames.length; i++) {
      _fFmpeg.writeFile(i < 10 ? '${fileName}_00$i.png' : i < 100 ? '${fileName}_0$i.png' : '${fileName}_$i.png', frames[i]);
    }

    await _fFmpeg.run([
      '-framerate', frameRate,
      '-i', '${fileName}_%03d.png',
      '-vf', 'palettegen=max_colors=$maxColors',
      //palettegen //palettegen=max_colors=256 //'palettegen=stats_mode=single:max_colors=256'
      'palette.png',
    ]);

    await _fFmpeg.run([
      '-framerate', frameRate,
      '-i', '${fileName}_%03d.png',
      '-i', 'palette.png',
      '-lavfi', 'paletteuse=dither=bayer:bayer_scale=5${loopDelay ? ', setpts=\'if(eq(N,${frames.length - 1}),2/TB,PTS)\'' : ''}',
      //'-filter_complex', //'[0:v][1:v]paletteuse',//'[0:v][1:v]paletteuse=dither=bayer:bayer_scale=5'
      // [0:v][1:v]paletteuse=dither=floyd_steinberg //[0:v][1:v]paletteuse ////paletteuse
      //'-t', '1',
      '-loop', loopNum,
      '-r', exportRate,
      '-f', 'gif',
      '$exportFileName.gif',
    ]);
    final gifData = _fFmpeg.readFile('$exportFileName.gif');
    _fFmpeg.unlink('$exportFileName.gif');
    return gifData;

  }

}
