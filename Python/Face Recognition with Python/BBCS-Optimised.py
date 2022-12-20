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

from threading import Thread
from queue import Queue

from cvlib import detect_face

global engine, run, speech
engine = pyttsx3.init()
run = True
speech = Queue()

def tts():
    while speech.qsize():
        run = False
        engine.say(speech.get())
        engine.runAndWait()
    run = True
    return

def say(text):
    speech.put(text)
    if run:
        Thread(target=tts).start()
    return

ENCODINGS_DIR = 'known_faces_encodings'
PIC_DIR = 'known_faces_pic'

TOLERANCE = float(input("Please specify desired tolerance (0.0 < Tolerance < 1.0): "))

FRAME_THICKNESS = 3
FONT_THICKNESS = 2

known_faces = [] # list of encodings
known_names = []

for name in os.listdir(ENCODINGS_DIR):
    for filename in os.listdir(f'{ENCODINGS_DIR}/{name}'):
        with open(f'{ENCODINGS_DIR}/{name}/{filename}', 'rb') as pklfile:
            encoding = pickle.load(pklfile)
            known_faces.append(encoding)
            known_names.append(name)

next_id = len(known_names)+1
copied_lst = []

video = cv2.VideoCapture(0)
colors = {}
tts_lst = []
tts_counter = 0
previous_locations = []
previous_matches_index = []
while True:
    #to put in the current TOP LEFT locations of the detected faces later, and also acts as a reset
    current_locations = [] # will consist of lists of [Left, Top]
    current_matches_index = [] #also acts as reset
    
    
    #Load video and flip
    image = cv2.flip(video.read()[1], 1)

    # This grabs the face locations, need them to draw boxes
    locations = [(i[1], i[2], i[3], i[0]) for i in detect_face(image)[0]]
                #top, right, bottom, left 

    for face_location in locations:
        results = []
        match = None

        #check for every location, if the location is close to a previous location
        top, left = face_location[0], face_location[3]
        counter = 0 #so i know the index
        found_flag = False
        
        for location in previous_locations: #if its empty it'll just skip
            #if the difference in pixels are less than 20, can assume its the same face
            if abs(location[0] - left) < 20 and abs(location[1] - top) < 20:
                match = known_names[previous_matches_index[counter]]
                found_flag = True
                current_locations.append([left, top])
                current_matches_index.append(previous_matches_index[counter])

                # greet the match
                if match not in tts_lst:
                    tts_lst.append(match)
                    sylables = str(match).replace('_', ' ', 10)
                    say(f'Hello there! {str(sylables)}')
                    say(random.choice(['Nice to meet you!', 'You look familiar.', 'How do you do?']))
                    
                    #if more than 6 names will remove the first name(refrshing temp memory)
                    if len(tts_lst) > 6:
                        tts_lst.pop(0)

                if match in tts_lst:
                    tts_counter += 1
                    if tts_counter % 500 == 0: #every 500th loop
                        tts_counter = 0
                        sylables = str(match).replace('_', ' ', 10)
                        say(f'Ohh Hi, {str(sylables)}. You are still here.')

                        
                break #since found already, break
            
               
            else:
                counter += 1
             

        #if theres no proximity matches from the last frame, then must run the whole thing to check who is it
        if found_flag == False:
           #face_dstance returns a confidence score,
           #the lower the scorer the 'closer' the encoding is to the known encoding, thus higher confidence, vice versa
            #encoding is the most time psending part, so only check when its necessary
            face_encoding = (face_recognition.face_encodings(image, [face_location]))[0] #it returns a list, of 1 element, so i take the first
            for i in list(face_recognition.face_distance(known_faces, face_encoding)): # returns confidence
                if i not in results: #prevent duplicates(for some reason theres occasionally duplicates due to zip i think)
                    results.append(i)
            try: #in case results are 0, meaning a new run
                closest = min(results)
            except:
                closest = 1


            if closest < TOLERANCE:
                #Identify the match from known_names, which have the same length as results
                match = known_names[results.index(closest)]

                #append the data of this location into the respective lists
                current_locations.append([face_location[3], face_location[0]])
                current_matches_index.append(results.index(closest))
                

                # greet the match
                if match not in tts_lst:
                    tts_lst.append(match)
                    #print(tts_lst)
                    sylables = str(match).replace('_', ' ', 10)
                    say(f'Hello there! {str(sylables)}')
                    say(random.choice(['Nice to meet you!', 'You look familiar.', 'How do you do?']))
                    
                    #if more than 6 names will remove the first name(refrshing temp memory)
                    if len(tts_lst) > 6:
                        tts_lst.pop(0)

                if match in tts_lst:
                    tts_counter += 1
                    if tts_counter % 500 == 0: #every 500th loop
                        tts_counter = 0
                        sylables = str(match).replace('_', ' ', 10)
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

                try: #Same
                  os.mkdir(f'known_faces_pic/{match}_Pic')
                except:
                  pass

                top, right, bottom, left = face_location

                face_image = image[top:bottom, left:right]
                pil_image = Image.fromarray(face_image)
                image_file = f'known_faces_pic/{match}_Pic/{match}-{timestamp}.png'
                pil_image.save(image_file)
                
                #UPDATING THE DATABASE IMMEDIATELY
                #greetunknown
                say('Hello, who are you?',)

                #Asking for input and showing the picture at the same time using pysimple gui
                name = psg.popup_get_text(f"Who is ID {match}? Press ENTER to skip this ID, Press 'D' to Delete this ID: ", title = f'ID {match}', image = image_file)

                #Iterate through each encoding in the folder(the encoding is a pickle)
                for encoding in os.listdir(f'{ENCODINGS_DIR}/{match}'): #just putting folder doesnt seem to work

                    #If ENTER or D
                    if name == '' or name == None or name == 'd' or name == 'D':
                        #just delete it , save alot of errors and trouble, regardless
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
                        
                        #same thing
                        current_locations.append([face_location[3], face_location[0]])
                        current_matches_index.append(index)

                    print('Done!')


                    if match in copied_lst:
                        shutil.rmtree(f'{ENCODINGS_DIR}/{match}')
                        shutil.rmtree(f'{PIC_DIR}/{match}_Pic')

        top, right, bottom, left = face_location

        try:
            color = colors[match]
        except:
            color = random.choice([(255, 0, 0), (0, 255, 0), (0, 0, 255), (0, 255, 255), (255, 255, 0), (255, 0, 255)])
            colors[match] = color

       # Paint frame
        cv2.rectangle(image, (left, top), (right, bottom), color, FRAME_THICKNESS)
        cv2.rectangle(image, (left, bottom), (right, bottom+22), color, cv2.FILLED)
        # Wite a name
        cv2.putText(image, match, (left + 10, bottom + 15), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (200, 200, 200), FONT_THICKNESS)

    #update previous
    previous_locations = current_locations
    previous_matches_index = current_matches_index
        
    cv2.imshow('', image)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        video.release()
        cv2.destroyAllWindows()
        break
