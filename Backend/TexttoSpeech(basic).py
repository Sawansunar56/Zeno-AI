from gtts import gTTS
from playsound import playsound

# Function to take string input from user
def get_input():
    text = input("Enter the text to convert to voice: ")
    return text

# Function to generate voice output using gTTS
def generate_voice_output(text):
    # Create gTTS object with input text and language
    tts = gTTS(text=text, lang='en', slow=False)

    # Save the voice output as an mp3 file
    tts.save('output.mp3')

    # Play the voice output
    playsound('output.mp3')

# Main function
if __name__ == '__main__':
    text = get_input()
    generate_voice_output(text)

