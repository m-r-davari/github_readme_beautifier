import 'dart:typed_data';

abstract class IGifOptimizer{

  Future<Uint8List> optimizeGif({required Uint8List originalGif});

}