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
  String _detectedObjectsText = "";
  bool _isLoading = false;
  final FlutterTts _flutterTts = FlutterTts();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _requestPermission() async {
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    await _requestPermission();

    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _detectedObjectsText = "";
        _isLoading = true;
      });
      await _processImage(_selectedImage!);
    } else {
      setState(() {
        _detectedObjectsText = 'No image selected.';
        _isLoading = false;
      });
    }
  }

  Future<void> _processImage(File image) async {
    await _sendImageForDetection(image);
  }

  Future<void> _sendImageForDetection(File image) async {
    try {
      final uri = Uri.parse(
        'http://192.168.1.8:5000/caption',
      ); // Update to /detect if needed

      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', image.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        final Map<String, dynamic> data = json.decode(responseString);
        final detection =
            data['detected'] ?? 'No objects detected'; // updated key

        setState(() {
          _detectedObjectsText = detection;
        });

        await _speakText(detection);
      } else {
        setState(() {
          _detectedObjectsText = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _detectedObjectsText = 'Failed to connect to server: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
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
      appBar: AppBar(title: const Text('Camera and Object Detection')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            else if (_detectedObjectsText.isNotEmpty)
              Column(
                children: [
                  Text(
                    'Detected Objects: $_detectedObjectsText',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => _speakText(_detectedObjectsText),
                    icon: const Icon(Icons.volume_up),
                    label: const Text('Repeat Detection Audio'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
