from flask import Flask, request, jsonify
from ultralytics import YOLO
import numpy as np
from PIL import Image
import pytesseract
from flask_cors import CORS
import os

app = Flask(__name__)
CORS(app)

# Set this if you're on Windows (update the path accordingly)
# pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

# Load YOLO model
model = YOLO('yolov5s.pt')

@app.route('/detect', methods=['POST'])
def detect():
    try:
        if 'image' not in request.files:
            return jsonify({'error': 'No image uploaded'}), 400

        file = request.files['image']
        image = Image.open(file.stream).convert('RGB')

        # YOLO detection
        results = model(np.array(image))
        class_names = model.names
        label_names = [class_names[int(cls)] for cls in results[0].boxes.cls.cpu().numpy()]
        detected_text = ", ".join(label_names)

        # OCR with Tesseract
        ocr_text = pytesseract.image_to_string(image)
        print("OCR Text:", ocr_text)  # Log to check if OCR is working

        return jsonify({
            'detected_objects': detected_text if detected_text else "No objects detected",
            'ocr_text': ocr_text if ocr_text.strip() else "No text detected"
        })

    except Exception as e:
        print("Server error:", e)
        return jsonify({'error': f'Server error: {str(e)}'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
