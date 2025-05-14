import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CameraUI extends StatefulWidget {
  const CameraUI({Key? key}) : super(key: key);

  @override
  _CameraUIState createState() => _CameraUIState();
}

class _CameraUIState extends State<CameraUI> {
  File? _selectedImage;
  String _detectionResultText = '';
  String _ocrText = '';
  bool _isLoading = false;
  List<Map<String, String>> _followUpQA = [];

  final FlutterTts _flutterTts = FlutterTts();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _requestPermission() async {
    await Permission.camera.request();
    await Permission.photos.request();
    await Permission.storage.request();
  }

  Future<void> _pickImage(ImageSource source) async {
    await _requestPermission();
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _detectionResultText = '';
        _ocrText = '';
        _followUpQA = [];
        _isLoading = false;
      });
    } else {
      setState(() {
        _detectionResultText = 'No image selected.';
        _ocrText = '';
        _followUpQA = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _sendImageForObjectDetection(File image) async {
    setState(() => _isLoading = true);

    try {
      final uri = Uri.parse('http://192.168.1.11:5000/detect');
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', image.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        final data = json.decode(responseString);

        final detectedObjects =
            (data['detected_objects'] as List<dynamic>?)?.join(', ') ??
            'No objects detected';

        final followupList =
            data['followups'] != null
                ? List<Map<String, String>>.from(
                  data['followups'].map<Map<String, String>>(
                    (item) => {
                      'question': item['question'].toString(),
                      'answer': item['answer'].toString(),
                    },
                  ),
                )
                : <Map<String, String>>[];

        setState(() {
          _detectionResultText = detectedObjects;
          _followUpQA = followupList;
        });

        await _speakText(detectedObjects);
      } else {
        setState(() {
          _detectionResultText = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _detectionResultText = 'Failed to connect to server: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendImageForOCR(File image) async {
    setState(() => _isLoading = true);

    try {
      final uri = Uri.parse('http://192.168.1.11:5000/ocr');
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', image.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        final data = json.decode(responseString);

        final ocrText = data['ocr_text'] ?? 'No text detected';

        final followupList =
            data['followups'] != null
                ? List<Map<String, String>>.from(
                  data['followups'].map<Map<String, String>>(
                    (item) => {
                      'question': item['question'].toString(),
                      'answer': item['answer'].toString(),
                    },
                  ),
                )
                : <Map<String, String>>[];

        setState(() {
          _ocrText = ocrText;
          _followUpQA = followupList;
        });

        await _speakText(ocrText);
      } else {
        setState(() {
          _ocrText = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _ocrText = 'Failed to connect to server: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _speakText(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Detection & OCR')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_selectedImage != null)
                Image.file(
                  _selectedImage!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                )
              else
                const Text('No image selected'),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo),
                    label: const Text('Gallery'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              if (_isLoading)
                const CircularProgressIndicator()
              else ...[
                ElevatedButton.icon(
                  onPressed:
                      _selectedImage != null
                          ? () => _sendImageForObjectDetection(_selectedImage!)
                          : null,
                  icon: const Icon(Icons.camera_enhance),
                  label: const Text('Detect Objects (YOLOv5)'),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed:
                      _selectedImage != null
                          ? () => _sendImageForOCR(_selectedImage!)
                          : null,
                  icon: const Icon(Icons.text_fields),
                  label: const Text('Extract Text (OCR)'),
                ),
              ],

              const SizedBox(height: 20),

              if (_detectionResultText.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detected Objects:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(_detectionResultText),
                    ElevatedButton.icon(
                      onPressed: () => _speakText(_detectionResultText),
                      icon: const Icon(Icons.volume_up),
                      label: const Text('Repeat Object Detection'),
                    ),
                  ],
                ),

              if (_ocrText.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'OCR Text:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(_ocrText),
                    ElevatedButton.icon(
                      onPressed: () => _speakText(_ocrText),
                      icon: const Icon(Icons.volume_up),
                      label: const Text('Repeat OCR Result'),
                    ),
                  ],
                ),

              if (_followUpQA.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text(
                  'AI Follow-Up Questions:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                ..._followUpQA.map(
                  (qa) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Q: ${qa['question']}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("A: ${qa['answer']}"),
                      TextButton.icon(
                        onPressed: () => _speakText(qa['answer'] ?? ''),
                        icon: const Icon(Icons.volume_up),
                        label: const Text("Speak Answer"),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
