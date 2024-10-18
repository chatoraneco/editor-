// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:fleather/fleather.dart';
// import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart';

// class EditorScreen extends StatefulWidget {
//   const EditorScreen({super.key});

//   @override
//   EditorScreenState createState() => EditorScreenState();
// }

// class EditorScreenState extends State<EditorScreen> {
//   FleatherController? _controller;
//   late FocusNode _focusNode;

//   @override
//   void initState() {
//     super.initState();
//     _focusNode = FocusNode();
//     _loadDocument().then((document) {
//       setState(() {
//         _controller = FleatherController(document: document);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Editor'),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: () => _saveDocument(context),
//           ),
//         ],
//       ),
//       body: _controller == null
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 if (Platform.isAndroid || Platform.isIOS)
//                   FleatherToolbar.basic(controller: _controller!),
//                 Divider(),
//                 Expanded(
//                   child: GestureDetector(
//                     onTapDown: (details) {
//                       // タップした位置を取得
//                       final RenderBox renderBox = context.findRenderObject() as RenderBox;
//                       final offset = renderBox.globalToLocal(details.globalPosition);

//                       // テキストのインデックスを計算
//                       final textPosition = _getTextPositionAtOffset(offset);
//                       final url = _getUrlAtOffset(textPosition);
//                       if (url != null) {
//                         _launchURL(url);
//                       }
//                     },
//                     child: FleatherEditor(
//                       padding: const EdgeInsets.all(16),
//                       controller: _controller!,
//                       focusNode: _focusNode,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   Future<ParchmentDocument> _loadDocument() async {
//     final file = File(Directory.systemTemp.path + "/quick_start.json");
//     if (await file.exists()) {
//       final contents = await file.readAsString();
//       return ParchmentDocument.fromJson(jsonDecode(contents));
//     }
//     final Delta delta = Delta()..insert("Fleather Quick Start\n");
//     return ParchmentDocument.fromDelta(delta);
//   }

//   void _saveDocument(BuildContext context) {
//     final contents = jsonEncode(_controller!.document);
//     final file = File('${Directory.systemTemp.path}/quick_start.json');
//     file.writeAsString(contents).then(
//       (_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Saved.')),
//         );
//       },
//     );
//   }

//   String? _getUrlAtOffset(TextPosition offset) {
//     final text = _controller?.document.toPlainText();
//     if (text != null && offset.offset < text.length) {
//       final urlPattern = r'(?:(http|https):\/\/[^\s]+)';
//       final regex = RegExp(urlPattern);
//       final matches = regex.allMatches(text);

//       for (var match in matches) {
//         if (match.start <= offset.offset && match.end >= offset.offset) {
//           return match.group(0);
//         }
//       }
//     }
//     return null;
//   }

//   void _launchURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//  TextPosition _getTextPositionAtOffset(Offset offset) {
//   final renderBox = _focusNode.context?.findRenderObject() as RenderBox?;
//   if (renderBox == null) {
//     return const TextPosition(offset: 0);
//   }

//   final localOffset = renderBox.globalToLocal(offset);
  
//   // FleatherEditorのスタイルを取得
//   final textStyle = TextStyle(fontSize: 14); // 必要に応じて変更
//   final textPainter = TextPainter(
//     text: TextSpan(
//       text: _controller!.document.toPlainText(),
//       style: textStyle,
//     ),
//     textDirection: TextDirection.ltr,
//   );

//   textPainter.layout(maxWidth: renderBox.size.width);
  
//   // デバッグログ
//   print('Local Offset: $localOffset');
//   print('TextPainter Size: ${textPainter.size}');

//   return textPainter.getPositionForOffset(localOffset);
// }

// }

























import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fleather/fleather.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  EditorScreenState createState() => EditorScreenState();
}

class EditorScreenState extends State<EditorScreen> {
  FleatherController? _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _loadDocument().then((document) {
      setState(() {
        _controller = FleatherController(document: document);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveDocument(context),
          ),
        ],
      ),
      body: _controller == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (Platform.isAndroid || Platform.isIOS)
                  FleatherToolbar.basic(controller: _controller!),
                Divider(),
                Expanded(
                  child: GestureDetector(
                    onTapDown: (details) {
                      // タップした位置を取得
                      final RenderBox renderBox = context.findRenderObject() as RenderBox;
                      final offset = renderBox.globalToLocal(details.globalPosition);

                      // テキストのインデックスを計算
                      final textPosition = _getTextPositionAtOffset(offset);
                      final url = _getUrlAtOffset(textPosition);
                      if (url != null) {
                        _launchURL(url);
                      }
                    },
                    child: FleatherEditor(
                      padding: const EdgeInsets.all(16),
                      controller: _controller!,
                      focusNode: _focusNode,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<ParchmentDocument> _loadDocument() async {
    final file = File(Directory.systemTemp.path + "/quick_start.json");
    if (await file.exists()) {
      final contents = await file.readAsString();
      return ParchmentDocument.fromJson(jsonDecode(contents));
    }
    final Delta delta = Delta()..insert("Fleather Quick Start\n");
    return ParchmentDocument.fromDelta(delta);
  }

  void _saveDocument(BuildContext context) {
    final contents = jsonEncode(_controller!.document);
    final file = File('${Directory.systemTemp.path}/quick_start.json');
    file.writeAsString(contents).then(
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved.')),
        );
      },
    );
  }

  String? _getUrlAtOffset(TextPosition offset) {
    final text = _controller?.document.toPlainText();
    if (text != null && offset.offset < text.length) {
      final urlPattern = r'(?:(http|https):\/\/[^\s]+)';
      final regex = RegExp(urlPattern);
      final matches = regex.allMatches(text);

      for (var match in matches) {
        if (match.start <= offset.offset && match.end >= offset.offset) {
          return match.group(0);
        }
      }
    }
    return null;
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  TextPosition _getTextPositionAtOffset(Offset offset) {
    // タップ位置を使ってテキストのインデックスを計算するロジックを実装
    // 一時的にインデックスを0に設定していますが、実際にはオフセットに基づいて計算する必要があります。
    
    // ここで、オフセットに基づいて適切な文字位置を特定するロジックを記述します。
    // 今は仮の処理として常に最初の位置を返します。
    return TextPosition(offset: 0); // 必要に応じて適切なインデックスを返してください。
  }


// TextPosition _getTextPositionAtOffset(Offset offset) {
//   // FleatherEditorのレンダーボックスを取得
//   final renderBox = _focusNode.context?.findRenderObject() as RenderBox?;
//   if (renderBox == null) {
//     return const TextPosition(offset: 0); // レンダーボックスがない場合
//   }

//   // グローバルオフセットをローカルオフセットに変換
//   final localOffset = renderBox.globalToLocal(offset);

//   // TextPainter を使ってテキストを描画
//   final textPainter = TextPainter(
//     text: TextSpan(
//       text: _controller!.document.toPlainText(),
//       style: TextStyle(fontSize: 14), // フォントサイズを適宜設定
//     ),
//     textDirection: TextDirection.ltr,
//   );

//   // レイアウトを計算
//   textPainter.layout(maxWidth: renderBox.size.width);

//   // タップした位置に基づいてテキスト位置を取得
//   return textPainter.getPositionForOffset(localOffset);
// }




}




