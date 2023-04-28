import requests
from playsound import playsound

def get_input():
    text = input("Enter the text to convert to voice: ")
    return text

def generate_voice_output(text):
    
    url = 'https://api.elevenlabs.io/v1/text-to-speech/ErXwobaYiN019PkySvjV'

    headers = {
    "xi-api-key": "d89cca94ae16dda144a14aabd4ff2e5a",
    "Content-Type": "application/json",
    "accept": "audio/mpeg"
    }
    data = {
    "text": text,
    "voice_settings": {
        "stability": 0.7,
        "similarity_boost": 0.5
    }
    }

    response = requests.post(url, headers=headers, json=data)

    if response.status_code == 200:
        with open("output.mp3", "wb") as f:
            f.write(response.content)
    else:
        print("Error:", response.status_code, response.text)

if __name__ == '__main__':
    text = get_input()
    generate_voice_output(text)
    playsound('output.mp3')
