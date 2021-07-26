#include <Key.h>
#include <Keypad.h>
#include <Time.h>
#include <TimeLib.h>
#include <LiquidCrystal_I2C.h>
#include <Bridge.h>
#include <Temboo.h>
#include "TembooAccount.h" // contains Temboo account information, as described below

// Pin init
const int sensor = 3;
const int close_valve = 8;
const int open_valve = 9;

// Variables to set
float budget = 100.0;
float flow_limit = 1.5;
float max_volume;

volatile int pulses = 0;
unsigned long curr_time;
unsigned long timing;
float flowrate;
float total_flow = 0;
float water_bill;
float monthly_rate;
int days_31[] = {1, 3, 5, 7, 8, 10, 12};
int last_day;
int psuedo_month = 1;
int psuedo_day = 1;
bool reported = false;
float highest = 0.0;
bool resetted = false;


const byte ROWS = 4; //four rows
const byte COLS = 4; //four columns
char keys[ROWS][COLS] = {
  {'1', '2', '3', 'A'},
  {'4', '5', '6', 'B'},
  {'7', '8', '9', 'C'},
  {'*', '0', '#', 'D'}
};
byte rowPins[ROWS] = {4, 5, 6, 7}; //connect to the row pinouts of the keypad
byte colPins[COLS] = {13, 12, 11, 10}; //connect to the column pinouts of the keypad
Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS );

LiquidCrystal_I2C lcd(0x27, 16, 2); // I2C address 0x27, 16 column and 2 rows

void pulse_count() {
  pulses += 1;
}

// Membrane keypad event manager
void keypadEvent(KeypadEvent key) {
  detachInterrupt(digitalPinToInterrupt(3));
  switch (keypad.getState()) {
      Console.println(key);
    case PRESSED:
      switch (key) {
        case 'A': reset();
          break;
      }
      break;
  }
}

// Screen clear to display current bill
void screen_reset(){
  lcd.clear();
  lcd.setCursor(2, 0); lcd.print('$');
  lcd.setCursor(3, 0); lcd.print(total_flow * monthly_rate, 7);
}

void set() {
  detachInterrupt(digitalPinToInterrupt(3));
  resetted = false;
  screen_reset();
  Console.println("Set");
  lcd.setCursor(1, 1); lcd.print("Set: ");
  String new_limit = "";
  bool finished = false;
  while (!finished) {
    lcd.setCursor(6, 1);
    lcd.print(new_limit);
    char key = keypad.getKey();
    if (key) {
      String pressed = " ";
      pressed[0] = key;
      if (key == 'D') {
        byte strlength = new_limit.length();
        if (strlength) {
          new_limit.remove(strlength - 1);
          screen_reset();
          lcd.setCursor(1, 1); lcd.print("Set: ");
        }
      }
      if (key != 'C' and key != 'D') {
        if (key == '*') {
          pressed[0] = '.';
        }
        new_limit += pressed;
      }
    }
    if (key == 'C') {
      finished = true;
    }
  }
  max_volume = new_limit.toFloat();

  screen_reset();
  lcd.setCursor(3, 1); lcd.print("Limit set!");
  delay(1000);
  screen_reset();

}

void setup() {
  lcd.init();
  lcd.backlight();
  keypad.addEventListener(keypadEvent);
  pinMode(sensor, INPUT_PULLUP);
  pinMode(open_valve, OUTPUT);
  pinMode(close_valve, OUTPUT);
  Serial.begin(9600);
  delay(4000);
  while (!Serial);
  Bridge.begin();
  Console.begin();
  set();
  curr_time = millis();
  attachInterrupt(digitalPinToInterrupt(sensor), pulse_count, RISING);
}

void loop() {
  attachInterrupt(digitalPinToInterrupt(sensor), pulse_count, RISING);
  timing = millis();
  char key = keypad.getKey();
  if (key) {
    Console.pr  intln(key);
  }
  if (total_flow < 4.0) {
    monthly_rate = 2.74;
  }
  else {
    monthly_rate = 3.69;
  }
  if ((timing - curr_time) >= 1000) {
    screen_reset();
    Console.println();
    Console.println(monthly_rate);
    flowrate = pulses / 450000.0;
    total_flow += flowrate;
    Console.print("Pulses: "); Console.println(pulses);
    Console.print(flowrate, 10); Console.println(" m^3/sec");
    Console.print("Total flowed: "); Console.println(total_flow, 5);
    Console.println(flow_limit);
    curr_time = timing;
    pulses = 0;
    billing();

    if (flowrate > highest) {
      highest = flowrate;
    }

    float volume_left = max_volume - total_flow;
    if (psuedo_day != last_day) {
      float flow_limit = volume_left / (last_day - psuedo_day);
      if (flowrate > flow_limit && resetted == false) {
        float change = ((flowrate - flow_limit) / highest) * 1000;
        int duration = map(change, 0, 1000, 0, 7500);
        digitalWrite(close_valve, HIGH);
        delay(duration);
        digitalWrite(close_valve, LOW);
        notify("Flow limit", "Flow limit exceeded");
      }
    }
    Console.print("Date: "); Console.print(psuedo_day); Console.print("/"); Console.print(psuedo_month); Console.println("/2020");
    psuedo_day += 1;
  }
}


void billing() {
  detachInterrupt(digitalPinToInterrupt(3));
  for (int i = 0; i < 7; i += 1) {
    if (days_31[i] == psuedo_month) {
      last_day = 31;
      break;
    }
    else if (psuedo_month == 2) {
      if (year() / 4 or year() / 100 or year() / 4000) {
        last_day = 29;
        break;
      }
      else {
        last_day = 28;
        break;
      }
    }
    else {
      last_day = 30;
      break;
    }
  }

  if (psuedo_day > last_day) {
    psuedo_day = 1;
    psuedo_month += 1;
    total_flow = 0;
  }

  if (psuedo_month > 12) {
    psuedo_month = 1;
  }
  if (psuedo_day == last_day) {
    reset();
    reported = false;
    Console.print("Monthly bill: $"); Console.println(total_flow * monthly_rate);
    char bill[10];
    dtostrf(total_flow * monthly_rate, 6, 4, bill);
    notify("Water Bill", bill);
  }
}

void reset() {
  detachInterrupt(digitalPinToInterrupt(3));
  resetted = true;
  screen_reset();
  digitalWrite(open_valve, HIGH);
  lcd.setCursor(3, 1); lcd.print("Resetting!");
  delay(10000);
  digitalWrite(open_valve, LOW);
  screen_reset();
  attachInterrupt(digitalPinToInterrupt(sensor), pulse_count, RISING);
}

void notify(String subject, String body) {
  detachInterrupt(digitalPinToInterrupt(3));
  lcd.setCursor(2, 1);
  lcd.print("RESTRICTING!");
  TembooChoreo SendEmailChoreo;

  // Invoke the Temboo client
  SendEmailChoreo.begin();

  // Set Temboo account credentials
  SendEmailChoreo.setAccountName(TEMBOO_ACCOUNT);
  SendEmailChoreo.setAppKeyName(TEMBOO_APP_KEY_NAME);
  SendEmailChoreo.setAppKey(TEMBOO_APP_KEY);

  // Set Choreo inputs
  SendEmailChoreo.addInput("FromAddress", "draguinohell@gmail.com");
  SendEmailChoreo.addInput("Username", "draguinohell@gmail.com");
  SendEmailChoreo.addInput("ToAddress", "draguinohell@gmail.com");
  SendEmailChoreo.addInput("Subject", subject);
  SendEmailChoreo.addInput("Password", "xzegfujbiicbqbwu");
  SendEmailChoreo.addInput("MessageBody", body);

  // Identify the Choreo to run
  SendEmailChoreo.setChoreo("/Library/Google/Gmail/SendEmail");

  // Run the Choreo; when results are available, print them to serial
  SendEmailChoreo.run();

  while (SendEmailChoreo.available()) {
    char c = SendEmailChoreo.read();
    Console.print(c);
  }
  screen_reset();
  SendEmailChoreo.close();

}
