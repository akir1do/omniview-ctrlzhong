from flask import Flask, request, jsonify
from ultralytics import YOLO
import numpy as np
from PIL import Image
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Load the YOLOv5 model
model = YOLO('yolov5s.pt')  # Ensure the path is correct and model exists

@app.route('/caption', methods=['POST'])  # You can also rename this to '/detect'
def detect():
    try:
        if 'image' not in request.files:
            return jsonify({'error': 'No image uploaded'}), 400

        file = request.files['image']
        image = Image.open(file.stream).convert('RGB')
        image = np.array(image)

        results = model(image)

        boxes = results[0].boxes.xyxy.cpu().numpy().tolist()
        labels = results[0].boxes.cls.cpu().numpy().tolist()
        confidences = results[0].boxes.conf.cpu().numpy().tolist()

        class_names = model.names
        label_names = [class_names[int(cls)] for cls in labels]
        detected_text = ", ".join(label_names)

        return jsonify({
            'detected': detected_text,
            'boxes': boxes,
            'labels': label_names,
            'confidences': confidences
        })

    except Exception as e:
        print(f"Error during processing: {e}")
        return jsonify({'error': f"Server error: {str(e)}"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
