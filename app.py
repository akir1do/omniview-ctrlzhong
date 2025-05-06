from flask import Flask, request, jsonify
from ultralytics import YOLO  # or use YOLOv5 if not using Ultralytics >=8
import numpy as np
from PIL import Image
from flask_cors import CORS  # For enabling CORS if needed

app = Flask(__name__)
CORS(app)  # Enable CORS for cross-origin requests (important for Flutter)

# Load YOLO model
model = YOLO('yolov5s.pt')  # Ensure the path to your model file is correct

@app.route('/caption', methods=['POST'])
def caption():
    try:
        # Ensure an image is provided in the request
        if 'image' not in request.files:
            return jsonify({'error': 'No image uploaded'}), 400

        # Get the image from the request
        file = request.files['image']
        image = Image.open(file.stream).convert('RGB')
        image = np.array(image)

        # Perform object detection
        results = model(image)

        # Extract bounding boxes, labels, and confidences
        boxes = results[0].boxes.xyxy.cpu().numpy().tolist()  # [x1, y1, x2, y2]
        labels = results[0].boxes.cls.cpu().numpy().tolist()
        confidences = results[0].boxes.conf.cpu().numpy().tolist()

        # Generate a caption based on labels
        caption = "Detected Objects: " + ", ".join([str(label) for label in labels])

        # Return the results as JSON
        return jsonify({
            'caption': caption,
            'boxes': boxes,
            'labels': labels,
            'confidences': confidences
        })

    except Exception as e:
        # Log the error to the server logs and return a 500 error
        print(f"Error during processing: {e}")
        return jsonify({'error': f"Server error: {str(e)}"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
