import 'dart:typed_data';
import 'package:js/js.dart';
import 'package:js/js_util.dart' as jsUtil;
import 'dart:html' as html;
import 'package:github_readme_beautifier/core/gif_optimizer/i_gif_optimizer.dart';


@JS('optimizeGifAndReturn')
external dynamic optimizeGifAndReturn(blob);

class GifOptimizer extends IGifOptimizer {

  @override
  Future<Uint8List> optimizeGif({required Uint8List originalGif})async{
    dynamic jsOptimizedLightGif = await jsUtil.promiseToFuture(optimizeGifAndReturn(html.Blob([originalGif])));
    final html.FileReader reader = html.FileReader();
    reader.readAsArrayBuffer(jsOptimizedLightGif[0]);
    await reader.onLoad.first;
    final Uint8List optimizedLightGif = Uint8List.fromList(reader.result as List<int>);
    return optimizedLightGif;
  }


}