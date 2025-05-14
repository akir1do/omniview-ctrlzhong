from flask import Flask, request, jsonify
from ultralytics import YOLO
import numpy as np
from PIL import Image
from flask_cors import CORS
import pytesseract

app = Flask(__name__)
CORS(app)

# Load the YOLOv5 model
model = YOLO('yolov5s.pt')  # Make sure the model exists

@app.route('/caption', methods=['POST'])  # Consider renaming to /analyze or similar
def detect_and_ocr():
    try:
        if 'image' not in request.files:
            return jsonify({'error': 'No image uploaded'}), 400

        file = request.files['image']
        image = Image.open(file.stream).convert('RGB')
        image_np = np.array(image)

        # Run YOLO object detection
        results = model(image_np)
        boxes = results[0].boxes.xyxy.cpu().numpy().tolist()
        labels = results[0].boxes.cls.cpu().numpy().tolist()
        confidences = results[0].boxes.conf.cpu().numpy().tolist()
        class_names = model.names
        label_names = [class_names[int(cls)] for cls in labels]

        # Run OCR using pytesseract
        ocr_text = pytesseract.image_to_string(image)

        return jsonify({
            'detected_objects': label_names,
            'boxes': boxes,
            'confidences': confidences,
            'ocr_text': ocr_text.strip()
        })

    except Exception as e:
        print(f"Error during processing: {e}")
        return jsonify({'error': f"Server error: {str(e)}"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
