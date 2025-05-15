from flask import Flask, request, jsonify
from ultralytics import YOLO
import numpy as np
from PIL import Image
import pytesseract
from flask_cors import CORS
import openai
<<<<<<< HEAD
import os
from dotenv import load_dotenv
=======
import traceback
import os
>>>>>>> 774722e40769b5f9698facbb349ccc52fc9c5352

# Load environment variables from .env file
load_dotenv()

# Initialize Flask app
app = Flask(__name__)
CORS(app)

# Load YOLOv5 model
<<<<<<< HEAD
model = YOLO('yolov5s.pt')  # Make sure this file is accessible

# Load OpenAI API key from environment variable
openai.api_key = os.getenv("OPENAI_API_KEY")
=======
model = YOLO('yolov5s.pt')

# Set your OpenAI API key securely
openai.api_key = os.getenv('OPENAI_API_KEY')  # Set this environment variable securely
>>>>>>> 774722e40769b5f9698facbb349ccc52fc9c5352

def generate_followup_questions(objects, ocr_text):
    try:
        prompt = f"""You are an assistant that analyzes images.
The image contains objects: {', '.join(objects) if objects else 'None'}.
The extracted text from the image is: "{ocr_text}".
Generate 3 relevant questions and their answers based on this image.

Format:
- Question: ...
  Answer: ...
"""

<<<<<<< HEAD
    try:
=======
>>>>>>> 774722e40769b5f9698facbb349ccc52fc9c5352
        response = openai.ChatCompletion.create(
            model='gpt-3.5-turbo',
            messages=[
                {"role": "system", "content": "You are an intelligent image analysis assistant."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.7,
            max_tokens=500
        )

        content = response['choices'][0]['message']['content']
        lines = content.strip().split('\n')
        qa_list = []
        question = None

        for line in lines:
            if line.lower().startswith('question:'):
                question = line[len('question:'):].strip()
            elif line.lower().startswith('answer:') and question:
                answer = line[len('answer:'):].strip()
                qa_list.append({'question': question, 'answer': answer})
                question = None

        return qa_list

    except Exception as e:
<<<<<<< HEAD
        print("OpenAI API error:", e)
=======
        print("Error generating follow-up questions:")
        traceback.print_exc()
>>>>>>> 774722e40769b5f9698facbb349ccc52fc9c5352
        return []

@app.route('/detect', methods=['POST'])
def detect():
    try:
        if 'image' not in request.files:
            return jsonify({'error': 'No image uploaded'}), 400

        file = request.files['image']
        image = Image.open(file.stream).convert('RGB')
        image_np = np.array(image)

        results = model(image_np)
<<<<<<< HEAD
        boxes = results[0].boxes.xyxy.cpu().numpy().tolist()
        labels = results[0].boxes.cls.cpu().numpy().tolist()
        confidences = results[0].boxes.conf.cpu().numpy().tolist()
=======

        # Initialize defaults
        boxes, confidences, label_names = [], [], []
>>>>>>> 774722e40769b5f9698facbb349ccc52fc9c5352

        if results and results[0].boxes:
            boxes = results[0].boxes.xyxy.cpu().numpy().tolist()
            labels = results[0].boxes.cls.cpu().numpy().tolist()
            confidences = results[0].boxes.conf.cpu().numpy().tolist()
            class_names = model.names
            label_names = [class_names[int(cls)] for cls in labels]

        # OCR extraction
        ocr_text = pytesseract.image_to_string(image).strip()

        # Generate follow-up questions
        followups = generate_followup_questions(label_names, ocr_text)

        return jsonify({
            'detected_objects': label_names,
            'boxes': boxes,
            'labels': label_names,
            'confidences': confidences,
            'followups': followups
        })

    except Exception as e:
        print("Server error in /detect route:")
        traceback.print_exc()
        return jsonify({'error': f'Server error: {str(e)}'}), 500

@app.route('/ocr', methods=['POST'])
def ocr():
    try:
        if 'image' not in request.files:
            return jsonify({'error': 'No image uploaded'}), 400

        file = request.files['image']
        image = Image.open(file.stream).convert('RGB')
        ocr_text = pytesseract.image_to_string(image).strip()

<<<<<<< HEAD
        # Detect objects for context
=======
>>>>>>> 774722e40769b5f9698facbb349ccc52fc9c5352
        image_np = np.array(image)
        results = model(image_np)

        label_names = []
        if results and results[0].boxes:
            labels = results[0].boxes.cls.cpu().numpy().tolist()
            class_names = model.names
            label_names = [class_names[int(cls)] for cls in labels]

        followups = generate_followup_questions(label_names, ocr_text)

        return jsonify({
            'ocr_text': ocr_text,
            'followups': followups
        })

    except Exception as e:
        print("Server error in /ocr route:")
        traceback.print_exc()
        return jsonify({'error': f'Server error: {str(e)}'}), 500

if __name__ == '__main__':
    # Use debug=True for development
    app.run(host='0.0.0.0', port=5000, debug=True)
