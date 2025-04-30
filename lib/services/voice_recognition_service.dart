import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceRecognitionService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  
  Future<bool> initialize() async {
    return await _speech.initialize();
  }

  Future<String> listen() async {
    String transcription = '';
    if (await _speech.isAvailable) {
      _speech.listen(onResult: (result) {
        transcription = result.recognizedWords;
      });
    }
    return transcription;
  }

  void stop() {
    _speech.stop();
  }
}
