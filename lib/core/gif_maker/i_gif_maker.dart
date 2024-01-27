import 'dart:typed_data';

abstract class IGifMaker {

  /// this method will make Git file with Uint8List
  Future<Uint8List> createGif(
    {required List<Uint8List> frames, String frameRate = '50', String exportRate = '20', required String fileName,
    String loopNum = '0', String maxColors = '200', bool loopDelay = false}
  );

}