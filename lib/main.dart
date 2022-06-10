import 'package:flutter/material.dart';
import 'package:speech_to_text_demo/speech_to_text_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpeechToTextDemo(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Voice Assistant'),
//         backgroundColor: const Color(0xff764abc),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         tooltip: 'Increment',
//          backgroundColor: const Color(0xff764abc),
//         child: const Icon(Icons.mic),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

// class MyHomePage2 extends StatefulWidget {
//   @override
//   _MyHomePage2State createState() => new _MyHomePage2State();
// }
//
// class _MyHomePage2State extends State<MyHomePage2> {
//   late SpeechRecognition _speech;
//
//   bool _speechRecognitionAvailable = false;
//   bool _isListening = false;
//
//   String transcription = '';
//
//
//   @override
//   initState() {
//     super.initState();
//     activateSpeechRecognizer();
//   }
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   void activateSpeechRecognizer() {
//     print('_MyHomePage2State.activateSpeechRecognizer... ');
//     _speech = new SpeechRecognition();
//     _speech.setAvailabilityHandler(onSpeechAvailability);
//     _speech.setCurrentLocaleHandler(onCurrentLocale);
//     _speech.setRecognitionStartedHandler(onRecognitionStarted);
//     _speech.setRecognitionResultHandler(onRecognitionResult);
//     _speech.setRecognitionCompleteHandler(onRecognitionComplete);
//     _speech
//         .activate()
//         .then((res) => setState(() => _speechRecognitionAvailable = res));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       home: new Scaffold(
//         appBar: new AppBar(
//           title: new Text('SpeechRecognition'),
//         ),
//         body: new Padding(
//             padding: new EdgeInsets.all(8.0),
//             child: new Center(
//               child: new Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   new Expanded(
//                       child: new Container(
//                           padding: const EdgeInsets.all(8.0),
//                           color: Colors.grey.shade200,
//                           child: new Text(transcription))),
//                   _buildButton(
//                     onPressed: _speechRecognitionAvailable && !_isListening
//                         ? () => start()
//                         : null,
//                     label: _isListening
//                         ? 'Listening...'
//                         : 'Listen (${selectedLang.code})',
//                   ),
//                   _buildButton(
//                     onPressed: _isListening ? () => cancel() : null,
//                     label: 'Cancel',
//                   ),
//                   _buildButton(
//                     onPressed: _isListening ? () => stop() : null,
//                     label: 'Stop',
//                   ),
//                 ],
//               ),
//             )),
//       ),
//     );
//   }
//
//
//
//
//
//   Widget _buildButton({String label, VoidCallback onPressed}) => new Padding(
//       padding: new EdgeInsets.all(12.0),
//       child: new RaisedButton(
//         color: Colors.cyan.shade600,
//         onPressed: onPressed,
//         child: new Text(
//           label,
//           style: const TextStyle(color: Colors.white),
//         ),
//       ));
//
//   void start() => _speech
//       .listen(locale: selectedLang.code)
//       .then((result) => print('_MyHomePage2State.start => result $result'));
//
//   void cancel() =>
//       _speech.cancel().then((result) => setState(() => _isListening = result));
//
//   void stop() => _speech.stop().then((result) {
//     setState(() => _isListening = result);
//   });
//
//   void onSpeechAvailability(bool result) =>
//       setState(() => _speechRecognitionAvailable = result);
//
//   void onCurrentLocale(String locale) {
//     print('_MyHomePage2State.onCurrentLocale... $locale');
//     setState(
//             () => selectedLang = languages.firstWhere((l) => l.code == locale));
//   }
//
//   void onRecognitionStarted() => setState(() => _isListening = true);
//
//   void onRecognitionResult(String text) => setState(() => transcription = text);
//
//   void onRecognitionComplete() => setState(() => _isListening = false);
//
//   void errorHandler() => activateSpeechRecognizer();
// }
