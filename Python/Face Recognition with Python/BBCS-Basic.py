import face_recognition
import os
import cv2
import pickle
from PIL import Image
import shutil
import PySimpleGUI as psg
import pyttsx3
import random
import datetime

engine = pyttsx3.init()

def say(text):
    engine.say(text)
    engine.runAndWait()
    return
ENCODINGS_DIR = 'known_faces_encodings'
PIC_DIR = 'known_faces_pic'

TOLERANCE = float(input("Please specify desired tolerance (0.0 < Tolerance < 1.0): "))   

FRAME_THICKNESS = 3
FONT_THICKNESS = 2

#counter for tts, so not every round it says
tts_counter = 0
tts_lst = [] #temporary memory of the last n names

#To capture the video
print('Loading known faces...')
known_faces = []
known_names = []

# organize known faces as subfolders of ENCODINGS_DIR
# Each subfolder's name becomes the label (name)
for name in os.listdir(ENCODINGS_DIR):
    print(f'Starting with {name}!')
    #load every file of faces of known person
    for filename in os.listdir(f"{ENCODINGS_DIR}/{name}"):
        print(f'Loading: {filename}')

        # Get 128-dimension face encoding
        # returns a list of found faces
        with open(f'{ENCODINGS_DIR}/{name}/{filename}', 'rb') as pkl_file:
            encoding = pickle.load(pkl_file)
            # Append encodings and name
            known_faces.append(encoding)
            known_names.append(name)
    print(f'Done with {name}!')

next_id = len(known_names) + 1

print('Processing unknown faces...')

copied_lst = []

video = cv2.VideoCapture(0)
colors = {}
while True:
    #Load video and flip
    image = cv2.flip(video.read()[1], 1)

    # This grabs the face locations, need them to draw boxes
    # Returns a list of (top, right, bottom, left) in order
    locations = face_recognition.face_locations(image)
    

    # assume that there might be more faces in an image - we can find faces of different people
    # so for each encoding at each location
    for face_location in locations:
        results = []
        counter = 0
        # encoding is the most time consuming part, so only check when its necesarry
        face_encoding = face_recognition.face_encodings(image, [face_location])[0] # returns a list, of 1 element, so I take the first

        # the lower the scorer the 'closer' the encoding is to the known encoding, thus higher confidence, vice versa
        for i in list(face_recognition.face_distance(known_faces, face_encoding)): # returns confidence
            if i not in results: #prevent duplicates(for some reason theres occasionally duplicates due to zip i think)
                results.append(i)

        try: #incase results are 0, meaning a new run
            closest = min(results)
        except:
            closest = 1

        if closest < TOLERANCE:
            #Identify the match from known_names, which have the same length as results
            match = known_names[results.index(closest)]

            # greet the match
            if match not in tts_lst:
                tts_lst.append(match)
                sylables = str(match).replace('_', ' ')
                say(f'Hello there! {str(sylables)}')
                say(random.choice(['Nice to meet you!', 'You look familiar.', 'How do you do?']))

                #if more than 6 names will remove the first name(refrshing temp memory)
                if len(tts_lst) > 6:
                    tts_lst.pop(0)

            if match in tts_lst:
                tts_counter += 1
                if tts_counter % 500 == 0: #every 500th loop
                    tts_counter = 0
                    sylables = str(match).replace('_', ' ')
                    say(f'Ohh Hi! {str(sylables)}. You are still here.')

        else:
            #Creates a new folder to store the unknown face, thus now known
            match = str(next_id)
            next_id += 1
            known_names.append(match)
            index = known_names.index(match) #so i know what index to change
            known_faces.append(face_encoding)
            try: #need this to prevent FileExistError
              os.mkdir(f'{ENCODINGS_DIR}/{match}')
            except:
              pass
            timestamp = int(datetime.datetime.utcnow().timestamp())
            with open(f'{ENCODINGS_DIR}/{match}/{match}-{timestamp}.pkl', 'wb') as pkl_file:
                pickle.dump(face_encoding, pkl_file)

            os.mkdir(f'known_faces_pic/{match}_Pic')
            top, right, bottom, left = face_location

            face_image = image[top:bottom, left:right]
            pil_image = Image.fromarray(face_image)
            image_file = f'known_faces_pic/{match}_Pic/{match}-{timestamp}.png'
            pil_image.save(image_file) #IT NEEDS PNG FILE FORMAT TO WORK

            #UPDATING THE DATABASE IMMEDIATELY
            #greetunknown
            say('Hello, who are you?',)

            #Asking for input and showing the picture at the same time using pysimple gui
            name = psg.popup_get_text(f"Who is ID {match}? Press ENTER to skip this ID, Press 'D' to Delete this ID: ", title = f'ID {match}', image = image_file)

            #Iterate through each encoding in the folder(the encoding is a pickle)
            for encoding in os.listdir(f'{ENCODINGS_DIR}/{match}'): #just putting folder doesnt seem to work
                #If ENTER or D
                if name == '' or name == None or name.upper() == 'D':
                    #just delete it , save alot of erros and trouble, regardless
                    shutil.rmtree(f'{ENCODINGS_DIR}/{match}')
                    shutil.rmtree(f'{PIC_DIR}/{match}_Pic')

                    #since i removed it, i should pop it out of the knwon_names and known_faces, which i just added earlier jn
                    known_names.pop()
                    known_faces.pop()

                #if a name was actually inputed
                else:
                    #if its an existing name
                    if name in os.listdir(ENCODINGS_DIR):
                        #so i know what to delete later
                        copied_lst.append(match)
                        shutil.copy(f'{ENCODINGS_DIR}/{match}/{encoding}', f'{ENCODINGS_DIR}/{name}/{encoding}')
                        #to remove .pkl extension
                        shutil.copy(f'{PIC_DIR}/{match}_Pic/{encoding[:-4]}.png', f'{PIC_DIR}/{name}/{encoding[:-4]}.png')

                    #if the name does not exist yet
                    else:
                        copied_lst.append(match)
                        os.mkdir(f'{ENCODINGS_DIR}/{name}')
                        os.mkdir(f'{PIC_DIR}/{name}')

                        shutil.copy(f'{ENCODINGS_DIR}/{match}/{encoding}', f'{ENCODINGS_DIR}/{name}/{encoding}')
                        #to remove .pkl extension
                        shutil.copy(f'{PIC_DIR}/{match}_Pic/{encoding[:-4]}.png', f'{PIC_DIR}/{name}/{encoding[:-4]}.png')

                    known_names[index] = name

                print('Done!')

                if match in copied_lst:
                    shutil.rmtree(f'{ENCODINGS_DIR}/{match}')
                    shutil.rmtree(f'{PIC_DIR}/{match}_Pic')
                
        try:
            color = colors[match]
        except:
            color = random.choice([(255, 0, 0), (0, 255, 0), (0, 0, 255), (0, 255, 255), (255, 255, 0), (255, 0, 255)])
            colors[match] = color
        top, right, bottom, left = face_location

        # Paint frame
        cv2.rectangle(image, (left, top), (right, bottom), color, FRAME_THICKNESS)
        cv2.rectangle(image, (left, bottom), (right, bottom+22), color, cv2.FILLED)

        # Wite a name
        cv2.putText(image, match, (left + 10, bottom + 15), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (200, 200, 200), FONT_THICKNESS)
    
    #Show video
    cv2.imshow('', image)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        video.release()
        cv2.destroyAllWindows()
        break
