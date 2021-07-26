import PySimpleGUI as sg
sg.theme('DarkGrey4')

layout = [[sg.Text('', size=(18, 1), font=(None, 18), key='input')],
          [sg.Button('7'), sg.Button('8'), sg.Button('9'), sg.Button("x\u00B2"), sg.Button('÷')],
          [sg.Button('4'), sg.Button('5'), sg.Button('6'), sg.Button("x\u207F"), sg.Button('x')],
          [sg.Button('1'), sg.Button('2'), sg.Button('3'), sg.Button("\u00B2\u221Ax"), sg.Button('-')],
          [sg.Button('c'), sg.Button('0'), sg.Button('='), sg.Button("\u207F\u221Ax"), sg.Button('+')],
          ]

# Setup PySimpleGUI
window = sg.FlexForm('CALCULATOR',
                     default_button_element_size=(5, 2),
                     auto_size_buttons=False,
                     grab_anywhere=False,
                     return_keyboard_events=True
                     )

window.Layout(layout)

display, process = '', ''
calculated, overflow = False, False

# Processes
operators = {'x' : '*', '÷' : '/', '+' : '+', '-' : '-'}
power_and_root = {"x\u207F": "**", "\u207F\u221Ax": "**(1/"}
square_and_sqrt = {"x\u00B2": "**2", "\u00B2\u221Ax": "**(0.5)"}

while True:  # Event Loop
    try:        
        event, values = window.read()            
        print(event)
        
        # Clear screen
        if calculated or event == 'c' or overflow:
            calculated = False
            display = ''
            
        # Close window   
        if event in  (None, 'Escape:27'):
            break
        
        # Backspace
        if event == "BackSpace:8":
            display = display[:-1]
            
        # Calculator function   
        elif event in ('1234567890'):
            if ("**2" in process) or overflow:
                display = ""
                process = ""
                overflow = False

            # Prevent the number from exceeding the screen    
            if len(display) <= 16:
                display += event
            
        # Basic operations    
        elif event in operators:    
            display += operators[event]
            process = display
            display = ''

        # Power n or root n
        if event in power_and_root:
            display += power_and_root[event]
            process = display
            display = ''
            
        # Calculation process    
        if event in ("\r", '=') or event in square_and_sqrt:
            if event in square_and_sqrt:
                if not(overflow):
                   display += square_and_sqrt[event]
                   calculated = True
            process += display
            
            if overflow: # Resets if result is too large for Python
                calculated = True
                continue
            
            else:
                if "**(1/" == process[-6:(0-len(event))]: 
                    process += ")"
                display = round(eval(process), 17)

            # Display if number too large for Python   
            if len(str(display)) > 32:
                display = "\u221e"
                process = ''
                calculated = True
                overflow = True

            # Rounding if whole number   
            if (".0" in str(display)) and (display == round(display, 1)):
                display = int(display)
            calculated = True            
    
    except Exception as e:
        
        # Divide by zero catching
        if e == "ZeroDivisionError":
            display = "Zero Division Error"

        # Catch invalid inputs
        elif e == "SyntaxError":
            display = "Error"
            
        calculated = True # Allows the calculator to reset
        
    window['input'].update(display)
    
window.close()
