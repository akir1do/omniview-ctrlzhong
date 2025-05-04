import cv2
import mediapipe as mp

# Initialize MediaPipe
mp_hands = mp.solutions.hands
hands = mp_hands.Hands(max_num_hands=1)
mp_draw = mp.solutions.drawing_utils

# Start camera
cap = cv2.VideoCapture(0)

while True:
    success, img = cap.read()
    img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    results = hands.process(img_rgb)

    if results.multi_hand_landmarks:
        for hand_landmarks in results.multi_hand_landmarks:
            mp_draw.draw_landmarks(img, hand_landmarks, mp_hands.HAND_CONNECTIONS)

            # Get landmark for index finger tip (landmark #8)
            index_finger_tip = hand_landmarks.landmark[8]
            h, w, _ = img.shape
            cx, cy = int(index_finger_tip.x * w), int(index_finger_tip.y * h)

            # Show circle at tip of index finger
            cv2.circle(img, (cx, cy), 10, (0, 255, 0), cv2.FILLED)
            cv2.putText(img, "Pointing", (cx + 20, cy), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 255, 0), 2)

    cv2.imshow("Hand Tracking", img)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()