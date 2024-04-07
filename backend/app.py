import base64
import requests
import os

from openai import OpenAI
from flask import Flask, request, jsonify
from PIL import Image
from io import BytesIO

from keras.models import load_model  # TensorFlow is required for Keras to work
from PIL import Image, ImageOps  # Install pillow instead of PIL
import numpy as np


app = Flask(__name__)

# OpenAI API Key
api_key = os.getenv("OPENAI_API_KEY")

client = OpenAI()

assistant = client.beta.assistants.create(
    name="Doc Assistant Bot",
    instructions="You are a doctor's personal assistant bot. Analyze the text and respond to the user's queries.",
    tools=[{"type": "retrieval"}],
    model="gpt-4-turbo-preview",
)

thread = client.beta.threads.create()


def get_image_desc(image_url):

    if image_url == "":
        return

    headers = {"Content-Type": "application/json", "Authorization": f"Bearer {api_key}"}

    payload = {
        "model": "gpt-4-vision-preview",
        "messages": [
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": "Can you describe the image in detail?",
                    },
                    {
                        "type": "image_url",
                        "image_url": image_url,
                    },
                ],
            }
        ],
        "max_tokens": 300,
    }

    response = requests.post(
        "https://api.openai.com/v1/chat/completions", headers=headers, json=payload
    )

    return response.json()["choices"][0]["message"]["content"]


def retrieve_diagnosis_1(image_data, text_data):
    img_data = get_image_desc(image_data)

    message = client.beta.threads.messages.create(
        thread_id=thread.id,
        role="user",
        content=f""" 
        The user is currently experiencing the following problems:
        {text_data}
        The user has also uploaded an image of the problem. The image is as follows:
        {img_data}
        Please ask me an additional yes or no question for more details.
        """,
    )

    run = client.beta.threads.runs.create_and_poll(
        thread_id=thread.id,
        assistant_id=assistant.id,
        instructions="You are a helpful doc assistant. Please ask the user an additional yes or no question for more details.",
    )

    while True:
        if run.status == "completed":
            messages = client.beta.threads.messages.list(thread_id=thread.id)
            return messages.data[0].content[0].text.value


def retrieve_diagnosis_2(question_response):
    message = client.beta.threads.messages.create(
        thread_id=thread.id,
        role="user",
        content=f""" 
        The user has responded to the question with the following:
        {question_response}
        Please ask me an additional yes or no question for more details.
        """,
    )

    run = client.beta.threads.runs.create_and_poll(
        thread_id=thread.id,
        assistant_id=assistant.id,
        instructions="You are a helpful doc assistant. Please ask the user an additional yes or no question for more details.",
    )

    while True:
        if run.status == "completed":
            messages = client.beta.threads.messages.list(thread_id=thread.id)
            return messages.data[0].content[0].text.value


def retrieve_diagnosis_3(question_response):
    message = client.beta.threads.messages.create(
        thread_id=thread.id,
        role="user",
        content=f""" 
        The user has responded to the question with the following:
        {question_response}
        
        """,
    )

    run = client.beta.threads.runs.create_and_poll(
        thread_id=thread.id,
        assistant_id=assistant.id,
        instructions="You are a helpful doc assistant. Please give a comprehensive diagnosis for the user's problem based on the information provided.",
    )

    while True:
        if run.status == "completed":
            messages = client.beta.threads.messages.list(thread_id=thread.id)
            return messages.data[0].content[0].text.value


@app.route("/callback", methods=["GET"])
def process_data():
    data = request.json
    image_b64 = request.args.get("image_link")
    text_data = request.args.get("text_data")

    if image_b64:
        image_data = image_b64
        # image_data = base64.b64decode(image_b64).decode("utf-8")
        txt_data = retrieve_diagnosis_1(image_data, text_data)

    # Return the processed data
    return jsonify({"message": "Question for user", "textData": txt_data})


@app.route("/callback2", methods=["POST"])
def process_data2():
    data = request.json
    question_response = data.get("question_response")

    txt_data = retrieve_diagnosis_2(question_response)

    # Return the processed data
    return jsonify({"message": "Question for user", "textData": txt_data})


@app.route("/callback3", methods=["POST"])
def process_data3():
    data = request.json
    question_response = data.get("question_response")

    txt_data = retrieve_diagnosis_3(question_response)

    # Return the processed data
    return jsonify({"message": "Final diagnosis", "textData": txt_data})


@app.route("/image-classification", methods=["POST"])
def image_classification():
    image = request.files["image"]
    image = Image.open(image)
    image.save("image.jpg")

    image_data = get_image_desc("image.jpg")

    # Disable scientific notation for clarity

    np.set_printoptions(suppress=True)

    # Load the model
    model = load_model("keras_Model.h5", compile=False)

    # Load the labels
    class_names = open("labels.txt", "r").readlines()

    # Create the array of the right shape to feed into the keras model
    # The 'length' or number of images you can put into the array is
    # determined by the first position in the shape tuple, in this case 1
    data = np.ndarray(shape=(1, 224, 224, 3), dtype=np.float32)

    # Replace this with the path to your image
    image = Image.open("image.jpg").convert("RGB")

    # resizing the image to be at least 224x224 and then cropping from the center
    size = (224, 224)
    image = ImageOps.fit(image, size, Image.Resampling.LANCZOS)

    # turn the image into a numpy array
    image_array = np.asarray(image)

    # Normalize the image
    normalized_image_array = (image_array.astype(np.float32) / 127.5) - 1

    # Load the image into the array
    data[0] = normalized_image_array

    # Predicts the model
    prediction = model.predict(data)
    index = np.argmax(prediction)
    class_name = class_names[index]
    confidence_score = prediction[0][index]

    # Print prediction and confidence score
    return jsonify({"class": class_name[2:], "confidence": confidence_score})


if __name__ == "__main__":
    app.run(host="localhost", port=5000, debug=True)
