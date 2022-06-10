import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:text_to_speech/text_to_speech.dart';

const kListening = 'Listening...';

class SpeechToTextDemo extends StatefulWidget {
  @override
  _SpeechToTextDemoState createState() => _SpeechToTextDemoState();
}

class _SpeechToTextDemoState extends State<SpeechToTextDemo>
    with WidgetsBindingObserver {
  final String TAG = 'SpeechToTextDemo';

  final TextEditingController _myController = TextEditingController();
  //final FocusNode _nodeText1 = FocusNode();

  // 1.
  late SpeechRecognition _speech;
  // 2.
  bool _isSpeechStarted = false;
  bool _speechRecognitionAvailable = false;
  // 3.
  bool _isListening = false;
  // 4.
  String transcription = '';
  String currentText = '';
  bool _isContentsPresent = false;
  // 5.
  bool _isEndOfSpeech = false;

  // 1.
  TextToSpeech tts = TextToSpeech();
  // 2.
  String _ttsGreet = 'How may I help you?';
  // 3.
  String _ttsStaticResult = 'Its very hot today';

  bool _isShowResult = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _activateSpeechRecognizer();
    _tts(_ttsGreet);
  }

  //----- Init methods -----//
  void _requestPermission() async {
    if (!await Permission.microphone.request().isGranted) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses =
          await [Permission.microphone].request();
      print(statuses[Permission.location]);
    }
  }

  void _activateSpeechRecognizer() {
    _requestPermission();

    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    //_speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    //_speech.setEndOfSpeechHandler(onEndOfSpeech);
    //_speech.setErrorHandler(errorHandler);
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  //----- Speech related methods -----//
  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onRecognitionStarted() {
    //currentText = _myController.text;
  }

  void onRecognitionResult(String text) {
    if (_isEndOfSpeech) {
      _isEndOfSpeech = false;
      return;
    }
    setState(() {
      transcription = text;
      _isListening = true;
      print('recognized text is- $transcription');
      //_myController.text = currentText + transcription;
      _myController.selection = TextSelection.fromPosition(
          TextPosition(offset: _myController.text.length));
    });
  }

  void onEndOfSpeech(String text) {
    print('End of speech encountered');
    setState(() {
      _isListening = false;
      _isEndOfSpeech = true;
      if (text != null && text.isNotEmpty) {
        _myController.text += ' ';
        _myController.selection = TextSelection.fromPosition(
            TextPosition(offset: _myController.text.length));
      }
    });
  }

  void onRecognitionComplete() {
    print('Recognition Completed');

    if (transcription.isNotEmpty) {
      _isContentsPresent = true;
      _processRequest(transcription);
      _toggleSpeechRecognitionStatus(isSpeechStarted: false);
      // Comment below line if you want to allow listening more when completed.
      //_toggleSpeechRecognitionStatus(isSpeechStarted: false);
    }
  }

  void errorHandler() => _activateSpeechRecognizer();

  _startSpeechRecognition() {
    _speech.listen(locale: 'en_US').then((result) {
      print('Started listening => result $result');
      _toggleSpeechRecognitionStatus(isSpeechStarted: true);
    });
  }

  _stopSpeechRecognition() {
    _speech.stop().then((result) {
      print('stopped listening => result $result');
      _toggleSpeechRecognitionStatus(isSpeechStarted: false);
    });
  }

  _toggleSpeechRecognitionStatus({required bool isSpeechStarted}) {
    // Toggle the keyboard layout
    //isSpeechStarted ? _nodeText1.unfocus() : _nodeText1.requestFocus();

    if (isSpeechStarted) {
      _myController.clear();
    }
    //if(!mounted) return;
    setState(() {
      _isSpeechStarted = isSpeechStarted;
      _isShowResult = !isSpeechStarted;
      _isListening = false;
    });
  }

  _processRequest(String transcription) {
    // Process request here
    /// Your business logic here
    //Speak out the result
    setState(() {
      _isShowResult = true;
    });
    _tts(_ttsStaticResult);
  }

  _tts(String message) {
    tts.speak(message);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    KeyboardVisibilityNotification().dispose();
    _myController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        //_speech.mute(true); //TODO
        break;
      // case AppLifecycleState.paused:
      // case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        //_speech.mute(false); //TODO
        _stopSpeechRecognition();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          height: 200,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 1.
              if (!_isSpeechStarted) ...[
                FloatingActionButton(
                  backgroundColor: const Color(0xff764abc),
                  child: Icon(
                    Icons.mic,
                    size: 35,
                  ),
                  onPressed: () {
                    _startSpeechRecognition();
                  },
                ),
              ] else ...[
                FloatingActionButton(
                  backgroundColor: const Color(0xff764abc),
                  child: Icon(
                    Icons.stop,
                    size: 35,
                  ),
                  onPressed: () {
                    _stopSpeechRecognition();
                  },
                ),
              ],
              // 2.
              if (_isListening) ...[
                Text(
                  kListening,
                  style: GoogleFonts.nunito(
                      textStyle:
                          TextStyle(color: Colors.black, fontSize: 22.5)),
                ),
              ],
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Voice Assistant'),
          backgroundColor: const Color(0xff764abc),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _ttsGreet,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 30.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                // 3.
                TextField(
                  controller: _myController,
                  readOnly: true,
                  onChanged: (String text) {
                    setState(() {
                      _isContentsPresent = text.isNotEmpty;
                    });
                  },
                  //focusNode: _nodeText1,
                  cursorColor: Colors.grey,
                  style:
                      GoogleFonts.poppins(textStyle: TextStyle(fontSize: 30.5)),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.nunito(),
                  ),
                ),
                // 4.
                if (_isShowResult)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _ttsStaticResult,
                        //textAlign: TextAlign.end,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 30.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
