from flask import Flask, request, jsonify
from ultralytics import YOLO
import numpy as np
from PIL import Image
import pytesseract
from flask_cors import CORS
from openai import OpenAI  # new style
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Initialize Flask app
app = Flask(__name__)
CORS(app)

# Load model and OpenAI client
model = YOLO('yolov5s.pt')
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

def generate_followup_questions(objects, ocr_text): #takes 2 inputs from yolov5 and tesseract ocr
    prompt = f"""You are an assistant that analyzes images.
The image contains objects: {', '.join(objects) if objects else 'None'}. 
The extracted text from the image is: "{ocr_text}".
Generate 3 relevant questions and their answers based on this image.

Format:
- Question: ...
  Answer: ...
""" #Describes what's in the images to GPT and generates 3 followup questions and answers

    try:
        response = client.chat.completions.create(
            model='gpt-3.5-turbo',
            messages=[
                {"role": "system", "content": "You are an intelligent image analysis assistant."}, #tells gpt what kind of assistant it is
                {"role": "user", "content": prompt}
            ],
            temperature=0.7, #more creative & varied responses
            max_tokens=500
        )

        content = response.choices[0].message.content #Extract assistant text response to convert into a format FLutter can use and display
        lines = content.strip().split('\n')
        qa_list = [] #empty list to store questions and answer
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
        print("OpenAI API error:", e)
        return []

@app.route('/detect', methods=['POST'])
def detect():
    try:
        if 'image' not in request.files:
            return jsonify({'error': 'No image uploaded'}), 400

        file = request.files['image']
        image = Image.open(file.stream).convert('RGB')
        image_np = np.array(image)

        results = model(image_np) #  YOLOV5 to detect the objects in image 

        #Extracts
        boxes = results[0].boxes.xyxy.cpu().numpy().tolist() # coordinates of each object
        labels = results[0].boxes.cls.cpu().numpy().tolist() #Class labels
        confidences = results[0].boxes.conf.cpu().numpy().tolist() #confidence score


        #Converts label IDS to object names
        class_names = model.names
        label_names = [class_names[int(cls)] for cls in labels]

        #tesseract to extract readable text
        ocr_text = pytesseract.image_to_string(image).strip()

        followups = generate_followup_questions(label_names, ocr_text) #Send list of detected objects and extracted text to GPT 

        return jsonify({
            'detected_objects': label_names,
            'boxes': boxes,
            'labels': label_names,
            'confidences': confidences,
            'followups': followups
        })

    except Exception as e:
        print("Server error (detect):", e)
        return jsonify({'error': f'Server error: {str(e)}'}), 500

@app.route('/ocr', methods=['POST'])
def ocr():
    try:
        if 'image' not in request.files:
            return jsonify({'error': 'No image uploaded'}), 400

        file = request.files['image']
        image = Image.open(file.stream).convert('RGB')
        ocr_text = pytesseract.image_to_string(image).strip()

        image_np = np.array(image) #convert to numpy array so yolov5 can process it
        results = model(image_np)
        labels = results[0].boxes.cls.cpu().numpy().tolist()
        class_names = model.names
        label_names = [class_names[int(cls)] for cls in labels]

        followups = generate_followup_questions(label_names, ocr_text)

        return jsonify({
            'ocr_text': ocr_text,
            'followups': followups
        })

    except Exception as e:
        print("Server error (ocr):", e)
        return jsonify({'error': f'Server error: {str(e)}'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
