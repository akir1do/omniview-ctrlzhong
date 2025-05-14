from flask import Flask, request, jsonify
from ultralytics import YOLO
import numpy as np
from PIL import Image
import pytesseract
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Load the YOLOv5 model
model = YOLO('yolov5s.pt')  # Make sure this file exists in the correct path

@app.route('/detect', methods=['POST'])  # Fixed route name from /caption
def detect():
    try:
        if 'image' not in request.files:
            return jsonify({'error': 'No image uploaded'}), 400

        file = request.files['image']
        image = Image.open(file.stream).convert('RGB')
        image_np = np.array(image)

        results = model(image_np)

        boxes = results[0].boxes.xyxy.cpu().numpy().tolist()
        labels = results[0].boxes.cls.cpu().numpy().tolist()
        confidences = results[0].boxes.conf.cpu().numpy().tolist()

        class_names = model.names
        label_names = [class_names[int(cls)] for cls in labels]
        detected_text = ", ".join(label_names)

        return jsonify({
            'detected_objects': label_names,
            'boxes': boxes,
            'labels': label_names,
            'confidences': confidences
        })

    except Exception as e:
        print("Server error (detect):", e)
        return jsonify({'error': f'Server error: {str(e)}'}), 500

@app.route('/ocr', methods=['POST'])  # New OCR endpoint
def ocr():
    try:
        if 'image' not in request.files:
            return jsonify({'error': 'No image uploaded'}), 400

        file = request.files['image']
        image = Image.open(file.stream).convert('RGB')

        ocr_text = pytesseract.image_to_string(image)

        return jsonify({
            'ocr_text': ocr_text.strip()
        })

    except Exception as e:
        print("Server error (ocr):", e)
        return jsonify({'error': f'Server error: {str(e)}'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
