###Attendance system
#added comparing differencee between pixel
#fixed tts

import face_recognition, cv2
import os, sys, shutil
import pickle
from PIL import Image
import PySimpleGUI as psg
import pyttsx3, random, datetime, csv, pickle
from threading import Thread
from queue import Queue
from cvlib import detect_face

print('Self learning Face Recognition trainer')
print('Version 1, Ng Kin Meng, Ansel Kee\n')

#i put in function so more robust, and less global variables, also cause i want to introduce some other stuff in future
def my_face_recognition():
    ENCODINGS_DIR = 'known_faces_encodings'
    PIC_DIR = 'known_faces_pic'

    #To capture the video
    video = cv2.VideoCapture(0)
    next_id = sum(len(os.listdir(f"known_faces_pic\{i}")) for i in os.listdir("known_faces_pic"))
    while True:
        try:
            image = cv2.flip(video.read()[1], 1)

            # This grabs the face locations, need them to draw boxes
            location = [(i[1], i[2], i[3], i[0]) for i in detect_face(image)[0]]
            if location:
                match = str(next_id)
                next_id += 1
                try: #need this to prevent FileExistError
                  os.mkdir(f'{ENCODINGS_DIR}/{match}')
                except:
                  pass
                timestamp = int(datetime.datetime.utcnow().timestamp())
                with open(f'{ENCODINGS_DIR}/{match}/{match}-{timestamp}.pkl', 'wb') as pkl_file:
                    pickle.dump(face_encoding, pkl_file)

                #i just created this so i know which id goes to who, i use pil cause idk how use cv2
                try: #Same
                  os.mkdir(f'known_faces_pic/{match}_Pic')
                except:
                  pass

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
                    if name in ('', None, 'd', 'D'):
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
                            #input('3')
                            copied_lst.append(match)
                            os.mkdir(f'{ENCODINGS_DIR}/{name}')
                            os.mkdir(f'{PIC_DIR}/{name}')
                            shutil.copy(f'{ENCODINGS_DIR}/{match}/{encoding}', f'{ENCODINGS_DIR}/{name}/{encoding}')

                            #to remove .pkl extension
                            shutil.copy(f'{PIC_DIR}/{match}_Pic/{encoding[:-4]}.png', f'{PIC_DIR}/{name}/{encoding[:-4]}.png')
                    if match in copied_lst:
                        shutil.rmtree(f'{ENCODINGS_DIR}/{match}')
                        shutil.rmtree(f'{PIC_DIR}/{match}_Pic')

            #Show video
            cv2.imshow('', image)
            if cv2.waitKey(1) & 0xFF == ord('q'):
                return
        except Exception as e:
            print(e)
            pass
my_face_recognition()
