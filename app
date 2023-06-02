from flask import Flask, render_template, request
from nltk.chat.util import Chat, reflections
import random

patterns = [
    (r'Hi|Hello|Hey', 
     ['Hello!', 
      'Hi there!', 
      'Hey!', 
      'How are you?']),
    (r'I am good how are you|How are you doing|How do you feel|How are you', 
     ['I am doing well, thank you for asking!', 
      'I feel great today!', 
      'I am fine, thanks for asking.']),
    
    (r"What's your name|What is your name|Who are you", 
     ['My name is Chatbot, pleased to meet you!', 
      'I am Chatbot, nice to meet you!']),
    (r'Where are you from|Where do you come from', 
     ['I was created by a programmer, so you could say I come from the digital world!', 
      'I do not have a physical location, I am a chatbot.']),
    (r'Who are you|what are you|what do you do', 
     ['I am a chatbot designed to have conversations with people.', 
      'I am here to chat with you and answer your questions.', 
      'I am an AI language model created by OpenAI.']),
    (r'What do you like to do|What are your hobbies',
     ['As a chatbot, I do not have hobbies, but I enjoy helping people!', 
      'I do not have hobbies, but I like learning new things.', 
      'My purpose is to assist you, so helping you is what I like to do.']),
    (r'what is your purpose|why were you created|what is your goal',
     ['I was created to chat with people and assist them with their questions.', 
      'My purpose is to help you with anything you need.', 
      'I am here to provide information and help you in any way I can.']),
    (r'Do you like music|What kind of music do you like', 
     ['I like all kinds of music!', 
      'I do not have personal preferences, but I can provide you with information on any genre you like.']),
    (r'What is the weather like today|How is the weather today|What is the temperature today', 
     ['I am sorry, I cannot answer that question as I am not connected to a live weather feed.', 
      'I do not have access to live weather data, sorry.']),
    
    (r'Goodbye|Bye|See you later|Talk to you later', 
     ['Goodbye!', 'Take care!', 'Bye!', 'Have a nice day!']),
    
    (r'What is the pressure of the boiler|What is the pressure', 
     ['The pressure is 1bar',
      'The pressure is 1,5bar', 
      'The pressure is 2bar',
      'The pressure is 2,5bar', 
      'The pressure is 3bar',
      'The pressure is 3,5bar', 
      'The pressure is 4bar',
      'The pressure is 4,5bar', 
      'The pressure is 5bar', 
      'The pressure is 6bar',
      'The pressure is 7bar']),
    
    (r'Is 1bar good|Is 1,5bar good|Is 2bar good|Is 2,5bar good|Is 3bar good', 
     ['Pressure is on low level, everything is okay!']),
    (r'Is 3,5bar good|Is 4bar good|Is 5bar good|Is 4,5bar good|Is 5bar good', 
     ['Pressure is on normal level, be careful, it might get worse!']),
    (r'Is 6bar good', 
     ['Pressure is on high level, please adjust it!']),
    (r'Is 7bar good', 
     ['Pressure is on extreme level, please stick to safety measures that you are provided with.']),
    
    (r'How to adjust the pressure|How to adjust it|How to lower the pressure|How to lower it', 
     ['....']),
    (r'What are the safety measures|What are the measures', 
     ['....']),
]

fallback_responses = [
    "I'm sorry, I don't have an answer for that. Can you please rephrase your question?",
    "I'm not sure I understand. Could you please provide more details?",
    "I apologize, but I couldn't find a matching response. Can you try asking in a different way?",
]

chatbot = Chat(patterns, reflections)

app = Flask(__name__)

def get_chatbot_response(user_input):
    response = chatbot.respond(user_input)
    if response:
        return response
    else:
        return random.choice(fallback_responses)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/chatbot', methods=['POST'])
def chatbot_response():
    user_input = request.form['user_input']
    response = get_chatbot_response(user_input)
    return response

if __name__ == '__main__':
    app.run(debug=True)