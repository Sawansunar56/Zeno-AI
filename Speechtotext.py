import speech_recognition as sr
import threading

def get_input():
    r = sr.Recognizer()
    with sr.Microphone() as source:
        print("Thou Shalt now Speak...")
        audio = r.listen(source)
        while True:
            try:
                text = r.recognize_google(audio)
                if text:
                    print("Text:")
                    print(text)
                event = threading.Event()
                input_thread = threading.Thread(target=wait_for_input, args=(event,))
                input_thread.start()
                event.wait()
                if stop_flag:
                    break
                else:
                    print("Listening...")
                    audio = r.listen(source)
            except sr.UnknownValueError:
                continue
            except sr.RequestError as e:
                print(f"Error: {e}")
                break

def wait_for_input(event):
    global stop_flag
    user_input = input("Press 'c' to continue or Enter to exit: ")
    if user_input.strip() == 'c':
        event.set()
    else:
        stop_flag = True
        event.set()

if __name__ == '__main__':
    stop_flag = False
    get_input()



