import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_recognition/speech_recognition.dart';

const kListening = 'Listening...';

class SpeechToTextDemo extends StatefulWidget {
  @override
  _SpeechToTextDemoState createState() => _SpeechToTextDemoState();
}

class _SpeechToTextDemoState extends State<SpeechToTextDemo>
    with WidgetsBindingObserver {
  final String TAG = 'SpeechToTextDemo';
  bool _showToolbar = false;

  final TextEditingController _myController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();

  late SpeechRecognition _speech;
  bool _isSpeechStarted = false;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  String transcription = '';
  String currentText = '';
  bool _isContentsPresent = false;
  bool _isEndOfSpeech = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _activateSpeechRecognizer();
    _initKeyboardListener();
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

  //----- Toolbar with mic icon -----//
  Widget _toolBar() => PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.greenAccent,
                  ),
                  onPressed: () => null),
              IconButton(
                  icon: Icon(
                    Icons.mic,
                    color: Colors.deepPurpleAccent,
                  ),
                  onPressed: () => _startSpeechRecognition()),
              IconButton(
                  icon: Icon(
                    Icons.add_a_photo,
                    color: Colors.grey,
                  ),
                  onPressed: () => null),
            ]),
      );

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

  void _initKeyboardListener() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (isVisible) {
        // LogUtil()
        //     .printLogger(tag: TAG, message: 'keyboard visibility $isVisible');
        if (!isVisible) {
          FocusScope.of(context).unfocus();
        }
        setState(() {
          _showToolbar = isVisible;
        });
      },
    );
  }

  //----- Speech related methods -----//

  // void cancel() =>
  //     _speech.cancel().then((result) => setState(() => _isListening = result));

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onRecognitionStarted() {
    currentText = _myController.text;
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
      _myController.text = currentText + transcription;
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
    isSpeechStarted ? _nodeText1.unfocus() : _nodeText1.requestFocus();

    //if(!mounted) return;
    setState(() {
      _isSpeechStarted = isSpeechStarted;
      _isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          height: 300,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Is Listening $_isListening'),
              // MultiWave(
              //   isStartAnimating: _isListening,
              // ),
              if (!_isSpeechStarted) ...[
                FloatingActionButton(
                  child: Icon(
                    Icons.stop,
                    size: 35,
                  ),
                  onPressed: () {
                    _stopSpeechRecognition();
                  },
                ),
              ] else ...[
                FloatingActionButton(
                  child: Icon(
                    Icons.stop,
                    size: 35,
                  ),
                  onPressed: () {
                    _stopSpeechRecognition();
                  },
                ),
              ],
              Text(
                kListening,
                style: GoogleFonts.nunito(
                    textStyle: TextStyle(color: Colors.black, fontSize: 22.5)),
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Voice Assistant'),
          backgroundColor: const Color(0xff764abc),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Stack(
            children: [
              Positioned(
                top: 16,
                left: 0,
                right: 0,
                bottom: 56,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _myController,
                        //readOnly: true, //TODO
                        onChanged: (String text) {
                          setState(() {
                            _isContentsPresent = text.isNotEmpty;
                          });
                        },
                        focusNode: _nodeText1,
                        cursorColor: Colors.grey,
                        style: GoogleFonts.nunito(
                            textStyle: TextStyle(fontSize: 22.5)),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.nunito(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_showToolbar)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _toolBar(),
                )
            ],
          ),
        ),
      ),
    );
  }
}
