
#include <dummy.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include <time.h>
#include <ESP32Servo.h>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <mutex>
#include <cmath>


#include <WiFi.h>
#include <Firebase_ESP_Client.h>

#include <addons/TokenHelper.h>
#include "addons/RTDBHelper.h"

#define WIFI_SSID "DESKTOP"       //nazwa sieci
#define WIFI_PASSWORD "3U16&f85"  //haslo sieci

#define API_KEY "AIzaSyD1LfWx1-K_4iyLDd***************qc"  //ze względów bezpieczeństwa bazy danych API_KEY został ocenzurowany
#define DATABASE_URL "https://inteligentny-dom-5c538-default-rtdb.europe-west1.firebasedatabase.app/"

#define USER_EMAIL "test@gmail.com"
#define USER_PASSWORD "test_aplikacji"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseJson firebaseJson;
FirebaseConfig config;

Servo servo;
std::mutex mtx;         // Muteks do synchronizacji dostępu do zmiennej globalnej
int currentAngle = 90;  // zmienna globalna do której dostęp ma getopenlevel() oraz
// jazdawdol() i jazdawgore()


unsigned long previousMillis = 0;      // Zmienna przechowująca poprzedni czas wykonania operacji
const unsigned long interval = 10000;  // Interwał czasowy (1 minuta)

unsigned long sendDataPrevMillis = 0;
unsigned long count = 0;

//poinzej sprawdzanie czasu dla alarmu, wykrycie ruchu włącza alarm zawsze tylko na 50 sekund
long actualTime = millis();  //pobieranie aktualnego czasu
long lastTrigger = 0;        //wcześniejszy czas do porównania z aktualnym
bool startTimer = false;

// pobieranie danych dot czasu z serwera NTP
const char* ntpServer = "pool.ntp.org";  //ADRES SERWERA
const long gmtOffset_sec = 3600 * 2;     // STREFA CZASOWA GMT +2
const int daylightOffset_sec = 0;        // CZAS ZIMOWY/LETNI

// przypisanie pobranych danych o czasie do zmiennych
int dayOfWeekIndex = -1;  //oznaczenie dnia tygodnia niedziela = 0, poniedzialek = 1, wtorek = 2,... sobota = 6,
int hour = 0;             //AKTUALNA GODZINA
int minute = 0;           //AKTUALNA MINUTA

// deklaracja pinów w układzie ESP32 - w nazwie piny z prototypu a faktycznie:
// przypisane piny zmieniono po wykonaniu płytki PCB
const int ledPin = 2;      // informacj o połączeniu z Bazą Danych lub braku
const int oneWireBus = 32;  //deklaracji pinu który będzie pobierał dane o temperaturze z czujnika temperatury
const int ledPin5 = 33;     // prezentacja stanu grzanie grzejnik1/brak grzania grzejnik1
const int ledPin18 = 13;   // swiatlo w salonie
const int ledPin21 = 12;   // swiatlo kuchnia
const int ledPin22 = 14;   // swiatlo lazienka
const int ledPin12 = 26;   // led alarm z czujnika ruchu
int servoPin = 35;         // Pin, do którego jest podłączony serwo SG90
int currentPosition = 90;



int buttonPin19 = 15;                    // wlacznik swiatla w salonie
volatile bool buttonPressed19 = false;   //flaga przerwania, wlacznik światła salon
int buttonPin23 = 4;                    // wlacznik swiatla kuchnia
volatile bool buttonPressed23 = false;   //flaga przerwania, wlacznik światła kuchnia
int buttonPin13 = 5;                    //wlacznik swiatla lazienka
volatile bool buttonPressed13 = false;   //flaga przerwania, wlacznik światła lazienka
int motionPin14 = 25;                    // sygnal z czujnika ruchu
volatile bool motionDetected14 = false;  //flaga przerwania, wykrycie ruchu przez czujnik
int buttonPin26 = 18;                    // przycisk jazdy w dół
int buttonPin27 = 19;                    // przycisk jazdy w górę
volatile bool buttonPressed26 = false;   //flaga przerwania FALLING - wysłanie danych po zwolnieniu przycisku sterownania rolety
volatile bool buttonPressed27 = false;   //flaga przerwanie FALLING - wysłanie danych po zwolnieniu przycisku sterownania rolety



//zmienne odpowiedzialne za obsługę serwa

int button26State = 0;  // Stan przycisku 1
int button27State = 0;  // Stan przycisku 2
int servoSpeed = 1;
int servoSpeed2 = 1;  //predkość serwa dla ruchu generowanego z bazy danych

bool isButtonHeld = false;  // Flaga określająca, czy przycisk jest trzymany
bool isButtonHeld2 = false;

bool isButtonHeld11 = false;  // Flaga określająca, czy przycisk jest trzymany
bool isButtonHeld22 = false;

//Task do obsługi ruchu sterowania roletą równolegle do pozostałych działań
TaskHandle_t servoTaskHandle;




// sprawdzenie połączenia z bazą danych
bool databaseconnection;

// domyslny stan alarmu
bool alarm1 = false;         //dzwiek syreny alarmowej
bool alarmturnedON = false;  //czy czujnik ruchu aktywny?

// poziom otwarcia rolety


bool previousButtonState = true;  //sprawdzic czy potrzebne
bool led18State = false;
bool led21State = false;
bool led22State = false;

// prezentacja stanu zalogowania do bazy danych przez poduł ESP32
bool ledStatus = false;
bool signupOK = false;

// domyślne wartości temperatury zmierzonej i oczekiwanej
double temperaturasalon = 0;
int settemperaturesalon = 10;

// aktualny stan pracy grzejnika do wysłania do bazy danych
bool grzaniestate = false;

//Komunikujemy, że będziemy korzysać z interfejsu OneWire
OneWire oneWire(oneWireBus);
//Komunikujemy, że czujnik będzie wykorzystywał interfejs OneWire
DallasTemperature sensors(&oneWire);

// poniżej funkcje przerwań wystawiające flagi



void IRAM_ATTR handleButtonInterrupt19() {  // przerwanie swiatlo salon
  buttonPressed19 = true;                   // Ustaw flagę wciśnięcia przycisku
}

void IRAM_ATTR handleButtonInterrupt23() {  // przerwanie swiatlo kuchnia
  buttonPressed23 = true;                   // Ustaw flagę wciśnięcia przycisku
}

void IRAM_ATTR handleButtonInterrupt13() {  // przerwanie swiatlo lazienka
  buttonPressed13 = true;                   // Ustaw flagę wciśnięcia przycisku
}

void IRAM_ATTR handleMotionInterrupt14() {  // przerwanie wykrycie ruchu
  motionDetected14 = true;                  // Ustaw flagę wykrycia ruchu
}

void IRAM_ATTR handleButtonInterrupt26() {  // przerwanie jazda w dol przycisk
  button26State = digitalRead(buttonPin26);

  if (button26State == LOW) {
    isButtonHeld = true;    // przerwanie dla dodatkowego wątku
    isButtonHeld11 = true;  // dodatkowa zmienna w celu unikniecia konfliktów między dodatkowym wątkiem dla wątku głównego
  } else {
    isButtonHeld = false;    // przerwanie dla dodatkowego wątku
    isButtonHeld11 = false;  // dodatkowa zmienna w celu unikniecia konfliktów między dodatkowym wątkiem dla wątku głównego
    buttonPressed26 = true;  // zwolnienie przycisku po którym nastapi wysłanie danych o poziomie otwracia rolety
  }                          // Ustaw flagę wykrycia ruchu
}

void IRAM_ATTR handleButtonInterrupt27() {  // przerwanie jazda w górę przycisk
  button27State = digitalRead(buttonPin27);

  if (button27State == LOW) {
    isButtonHeld2 = true;
    isButtonHeld22 = true;
  } else {
    isButtonHeld2 = false;
    isButtonHeld22 = false;
    buttonPressed27 = true;  // zwolnienie przycisku po którym nastapi wysłanie danych o poziomie otwracia rolety
  }


}  // Ustaw flagę wykrycia ruchu





void servoControlTask(void* pvParameters);
void jazdawgore();
void jazdawdol();


// w poniższej petli nastepuje połączenie z siecia WIFI a następnie z bazą danych realtime database

void setup() {


  Serial.println("program zaczyna prace");

  // deklaracja pinów

  servo.attach(servoPin);
  servo.write(currentAngle);

  pinMode(ledPin, OUTPUT);             // dioda na module esp32 niebieska - potwierdzenie połączenia z bazą danych
  pinMode(ledPin5, OUTPUT);            // stan grzejnika1 grzeje/niegrzeje
  pinMode(ledPin18, OUTPUT);           // salon swiatlo
  pinMode(ledPin21, OUTPUT);           // kuchnia swiatlo
  pinMode(ledPin22, OUTPUT);           // lazienka swiatlo
  pinMode(ledPin12, OUTPUT);           // led alarm - z czujnika ruchu
  pinMode(buttonPin19, INPUT_PULLUP);  //wlacznik swiatla salon
  pinMode(buttonPin23, INPUT_PULLUP);  //wlacznik swiatla kuchnia
  pinMode(buttonPin13, INPUT_PULLUP);  //wlacznik swiatla lazienka
  pinMode(motionPin14, INPUT_PULLUP);  //informacja z czujnika ruchu
  pinMode(buttonPin26, INPUT_PULLUP);  //przycisk jzdy w dół
  pinMode(buttonPin27, INPUT_PULLUP);  //przycisk jazdy w górę

  attachInterrupt(digitalPinToInterrupt(buttonPin19), handleButtonInterrupt19, RISING);
  attachInterrupt(digitalPinToInterrupt(buttonPin23), handleButtonInterrupt23, RISING);
  attachInterrupt(digitalPinToInterrupt(buttonPin13), handleButtonInterrupt13, RISING);
  attachInterrupt(digitalPinToInterrupt(motionPin14), handleMotionInterrupt14, RISING);
  attachInterrupt(digitalPinToInterrupt(buttonPin26), handleButtonInterrupt26, CHANGE);
  attachInterrupt(digitalPinToInterrupt(buttonPin27), handleButtonInterrupt27, CHANGE);
  // attachInterrupt(digitalPinToInterrupt(buttonPin26), handleButtonInterrupt26falling, FALLING);
  // attachInterrupt(digitalPinToInterrupt(buttonPin27), handleButtonInterrupt27falling, FALLING);



  Serial.begin(115200);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback;
  if (Firebase.signUp(&config, &auth, "", "")) {
    Serial.println("signUp OK");
    signupOK = true;
  } else {
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }
  //config.token_status_callback - tokenStatusCallback;
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  // Init and get the time // czas bedzie utrzymywany przez lokalny moduł w przypadku braku WIFI
  configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);
  printLocalTime();

  // wifiSemaphore = xSemaphoreCreateMutex();



  // Utworzenie wątku przypisanego do rdzenia 1
  // Nazwa funkcji wątku, nazwa procesu, deklaracja rozmiaru stosu, przekazywane argumenty, priorytet, uchwyt, rdzeń procesora
  xTaskCreatePinnedToCore(servoControlTask, "Task", 1000, NULL, 1, NULL, 1);

  Serial.println("koniec petli setup");
}


// petla odpowiedzialna za obsługę sterowania ręcznego

void loop() {
  // ODESŁANIE DO POZOSTAŁYCH CZĘŚCI PROGRAMU


  Serial.println("zaczynam petle loop");
  przerwania();
  getopenlevel();                   // pobieranie informacji o wartości rolety z bazy danych
  printLocalTime();                 // przypisuje aktualny czas z serwera do zmiennych
  mesuretemperaturesalon();         //pomiar temperatury i wysłanie informacji do realtime database
  temperatureautomation();          // mocno obciążająca pętla
  grzalka();                        // wysyłanie informacji na temat aktualnej wartośc grzejnika do bazy danych realtimedatabase
  databasesalonlightstearing();     // sterowanie swiatlem w salonie z poziomu aplikacji mobilnej
  databasebathroomlightstearing();  // sterowanie swiatlem w łazience z poziomu aplikacji mobilnej
  databasekitchenlightstearing();   // sterowanie swiatlem w kuchni z poziomu aplikacji mobilnej
  deactivatealarm();                // deaktywacja alarmu 15 sekund po wykryciu ruchu
  getinformationabputsecurity();    // pobieranie informacji



  //zamykanieroletyprzycisk();



  // SPRAWDZA CZY POŁĄCZONO Z BAZĄ - JEŚLI TAK ZAŚWIECA NIEBIESKĄ DIODĘ NA MODULE

  if (Firebase.ready()) {
    digitalWrite(ledPin, true);
    databaseconnection = true;
  } else {
    digitalWrite(ledPin, false);
    databaseconnection = false;
    return;
  }

  // WYSYŁANIE/ODBIÓR DANYCH
  if (Firebase.ready() && (millis() - sendDataPrevMillis > 100 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();
  }
}



void bathroomlightstearing() {

  if (led22State == false) {
    digitalWrite(ledPin22, true);
    led22State = true;  // Włącz diodę LED
  } else {
    digitalWrite(ledPin22, false);
    led22State = false;  // Wyłącz diodę LED
  }
  // Ustaw nowy stan diody LED/""
  //senddata();

  if (Firebase.RTDB.setBool(&fbdo, "/Salon/swiatlo_lazienka", led22State)) {
  } else {
    Serial.println("error" + fbdo.errorReason());
  }
  Serial.println("ZREALIZOWAŁEM sterowanie swiatlem Z wifi");
  //Poczekaj chwilę, aby uniknąć odczytu przypadkowego przy dłuższym przytrzymaniu przycisku
  delay(10);
}

void kitchenlightstearing() {

  if (led21State == false) {
    digitalWrite(ledPin21, true);
    led21State = true;  // Włącz diodę LED
  } else {
    digitalWrite(ledPin21, false);
    led21State = false;  // Wyłącz diodę LED
  }
  // Ustaw nowy stan diody LED/""
  //senddata();

  if (Firebase.RTDB.setBool(&fbdo, "/Salon/swiatlo_kuchnia", led21State)) {
  } else {
    Serial.println("error" + fbdo.errorReason());
  }
  Serial.println("ZREALIZOWAŁEM sterowanie swiatlem Z wifi");
  //Poczekaj chwilę, aby uniknąć odczytu przypadkowego przy dłuższym przytrzymaniu przycisku
  delay(10);
}

void salonlightstearing() {  //sterowanie reczne z panelu ręcznego w aplikacji mobilnej + fizyczny włącznik światła



  if (led18State == false) {
    digitalWrite(ledPin18, true);
    led18State = true;  // Włącz diodę LED
  } else {
    digitalWrite(ledPin18, false);
    led18State = false;  // Wyłącz diodę LED
  }
  // Ustaw nowy stan diody LED/""
  //senddata();

  if (Firebase.RTDB.setBool(&fbdo, "/Salon/swiatlo", led18State)) {
  } else {
    Serial.println("error" + fbdo.errorReason());
  }
  Serial.println("ZREALIZOWAŁEM sterowanie swiatlem Z wifi");
  //Poczekaj chwilę, aby uniknąć odczytu przypadkowego przy dłuższym przytrzymaniu przycisku
  delay(10);
  //}
}

void databasekitchenlightstearing() {
  przerwania();


  if (Firebase.RTDB.getBool(&fbdo, "/Salon/swiatlo_kuchnia")) {
    if (fbdo.dataType() == "boolean") {
      led21State = fbdo.boolData();
      digitalWrite(ledPin21, led21State);

      // Serial.println("READ DATA FROM REALTIME DATABASE - SUCCES");
    } else {
      Serial.println("FAILED READ DATA OF LED FROM REALTIME DATABASE");
    }
  }
}

void databasebathroomlightstearing() {
  przerwania();


  if (Firebase.RTDB.getBool(&fbdo, "/Salon/swiatlo_lazienka")) {
    if (fbdo.dataType() == "boolean") {
      led22State = fbdo.boolData();
      digitalWrite(ledPin22, led22State);

      // Serial.println("READ DATA FROM REALTIME DATABASE - SUCCES");
    } else {
      Serial.println("FAILED READ DATA OF LED FROM REALTIME DATABASE");
    }
  }
}

void databasesalonlightstearing() {
  przerwania();



  if (Firebase.RTDB.getBool(&fbdo, "/Salon/swiatlo")) {
    if (fbdo.dataType() == "boolean") {
      led18State = fbdo.boolData();
      digitalWrite(ledPin18, led18State);

      // Serial.println("READ DATA FROM REALTIME DATABASE - SUCCES");
    } else {
      Serial.println("FAILED READ DATA OF LED FROM REALTIME DATABASE");
    }
  }
}


void mesuretemperaturesalon() {
  przerwania();
  databasesalonlightstearing();     // sterowanie swiatlem w salonie z poziomu aplikacji mobilnej
  databasebathroomlightstearing();  // sterowanie swiatlem w łazience z poziomu aplikacji mobilnej
  databasekitchenlightstearing();


  // CZĘŚĆ ODPOWIEDZIALNA ZA ODCZYT TEMPERATURY
  // put your main code here, to run repeatedly:
  // Odczyt temperatury
  sensors.requestTemperatures();
  //Odczyt w stopniach celsjusza
  float temperatureC = sensors.getTempCByIndex(0);
  //Odczyt w stopniach Farenheita
  float temperatureF = sensors.getTempFByIndex(0);
  delay(10);
  temperaturasalon = temperatureC;

  //Wysylanie informacji o temperaturze
  if (Firebase.RTDB.setDouble(&fbdo, "/Salon/temperatura", temperaturasalon)) {
  } else {
    Serial.println("error" + fbdo.errorReason());
  }
}



void temperatureautomation() {

  // TA LOGIKA JEST DOBRZE ZOPTYMALIZOWANA ALE POWODUJE CZASEM BŁĘDY W ODCZYCIE - tymczasowo dłuższa wersja
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // for (int i = 1; i <= 10; i++) {
  //   String path = "/Grzejnik1/Zasada" + String(i);
  //   if (Firebase.RTDB.getBool(&fbdo, path + "/delete") && !fbdo.boolData()) {
  //     String days[] = {"pn", "wt", "sr", "cz", "pt", "so"};
  //     if (dayOfWeekIndex >= 1 && dayOfWeekIndex <= 6) {
  //       if (Firebase.RTDB.getBool(&fbdo, path + "/" + days[dayOfWeekIndex - 1])) {
  //         int starthourPN = 0, startminutePN = 0, endhourPN = 0, endminutePN = 0;
  //         bool checkstartminute = true, checkendminute = true;

  //         if (Firebase.RTDB.getInt(&fbdo, path + "/start_time_hour")) {
  //           starthourPN = fbdo.intData();
  //         }

  //         if (Firebase.RTDB.getInt(&fbdo, path + "/start_time_minute")) {
  //           startminutePN = fbdo.intData();
  //         }

  //         if (Firebase.RTDB.getInt(&fbdo, path + "/end_time_hour")) {
  //           endhourPN = fbdo.intData();
  //         }

  //         if (Firebase.RTDB.getInt(&fbdo, path + "/end_time_minute")) {
  //           endminutePN = fbdo.intData();
  //         }

  //         checkstartminute = (hour == starthourPN) ? (minute > startminutePN) : true;
  //         checkendminute = (hour == endhourPN) ? (minute < endminutePN) : true;

  //         if (checkstartminute && checkendminute) {
  //           if (Firebase.RTDB.getInt(&fbdo, path + "/temperature")) {
  //             settemperaturesalon = fbdo.intData();
  //           } else {
  //             Serial.println("FAILED READ DATA OF LED FROM REALTIME DATABASE");
  //           }
  //         }
  //       }
  //     } else if (dayOfWeekIndex == 0) {
  //       if (Firebase.RTDB.getBool(&fbdo, path + "/nd")) {
  //         int starthourPN = 0, startminutePN = 0, endhourPN = 0, endminutePN = 0;
  //         bool checkstartminute = true, checkendminute = true;

  //         if (Firebase.RTDB.getInt(&fbdo, path + "/start_time_hour")) {
  //           starthourPN = fbdo.intData();
  //         }

  //         if (Firebase.RTDB.getInt(&fbdo, path + "/start_time_minute")) {
  //           startminutePN = fbdo.intData();
  //         }

  //         if (Firebase.RTDB.getInt(&fbdo, path + "/end_time_hour")) {
  //           endhourPN = fbdo.intData();
  //         }

  //         if (Firebase.RTDB.getInt(&fbdo, path + "/end_time_minute")) {
  //           endminutePN = fbdo.intData();
  //         }

  //         checkstartminute = (hour == starthourPN) ? (minute > startminutePN) : true;
  //         checkendminute = (hour == endhourPN) ? (minute < endminutePN) : true;

  //         if (checkstartminute && checkendminute) {
  //           if (Firebase.RTDB.getInt(&fbdo, path + "/temperature")) {
  //             settemperaturesalon = fbdo.intData();
  //           } else {
  //             Serial.println("FAILED READ DATA OF LED FROM REALTIME DATABASE");
  //           }
  //         }
  //       }
  //     }
  //   }
  // }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //dłuzsza wersja ponizej:
  for (int i = 1; i <= 10; i++) {



    if (Firebase.RTDB.getBool(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/delete")) {  //sprawdza czy zasada 1 jest aktywna
      if (fbdo.dataType() == "boolean") {
        bool delete1 = fbdo.boolData();
        if (delete1 == false) {

          // na chwile
          przerwania();
          getopenlevel();
          databasesalonlightstearing();     // sterowanie swiatlem w salonie z poziomu aplikacji mobilnej
          databasebathroomlightstearing();  // sterowanie swiatlem w łazience z poziomu aplikacji mobilnej
          databasekitchenlightstearing();


          if (Firebase.RTDB.getBool(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/pn")) {  //sprawdza czy zasada wytepuje w czwartek
            if (fbdo.dataType() == "boolean") {
              bool pn = fbdo.boolData();
              if (pn == true && dayOfWeekIndex == 1) {

                int starthourPN;
                int startminutePN;
                int endhourPN;
                int endminutePN;
                bool checkstartminute;
                bool checkendminute;

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/start_time_hour")) {
                  if (fbdo.dataType() == "int") {
                    starthourPN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/start_time_minute")) {
                  if (fbdo.dataType() == "int") {
                    startminutePN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/end_time_hour")) {
                  if (fbdo.dataType() == "int") {
                    endhourPN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/end_time_minute")) {
                  if (fbdo.dataType() == "int") {
                    endminutePN = fbdo.intData();
                  }
                }

                if (hour == starthourPN) {
                  if (minute > startminutePN) {
                    checkstartminute = true;
                  } else {
                    checkstartminute = false;
                  }
                } else {
                  checkstartminute = true;
                }

                if (hour == endhourPN) {
                  if (minute < endminutePN) {
                    checkendminute = true;
                  } else {
                    checkendminute = false;
                  }
                } else {
                  checkendminute = true;
                }



                //if(((hour>starthourPN)&&(checkstartminute = true)) && ((hour<endhourPN)&&(checkendminute = true)))
                if ((hour > starthourPN || (hour == starthourPN && minute >= startminutePN)) && (hour < endhourPN || (hour == endhourPN && minute <= endminutePN))) {

                  if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/temperature")) {
                    if (fbdo.dataType() == "int") {
                      settemperaturesalon = fbdo.intData();
                    } else {
                      Serial.println("FAILED READ DATA OF LED FROM REALTIME DATABASE");
                    }
                  }
                }
              }
            }
          }



          przerwania();
          getopenlevel();
          databasesalonlightstearing();     // sterowanie swiatlem w salonie z poziomu aplikacji mobilnej
          databasebathroomlightstearing();  // sterowanie swiatlem w łazience z poziomu aplikacji mobilnej
          databasekitchenlightstearing();


          if (Firebase.RTDB.getBool(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/wt")) {  //sprawdza czy zasada wytepuje w czwartek
            if (fbdo.dataType() == "boolean") {
              bool wt = fbdo.boolData();
              if (wt == true && dayOfWeekIndex == 2) {

                int starthourPN;
                int startminutePN;
                int endhourPN;
                int endminutePN;
                bool checkstartminute;
                bool checkendminute;

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/start_time_hour")) {
                  if (fbdo.dataType() == "int") {
                    starthourPN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/start_time_minute")) {
                  if (fbdo.dataType() == "int") {
                    startminutePN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/end_time_hour")) {
                  if (fbdo.dataType() == "int") {
                    endhourPN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/end_time_minute")) {
                  if (fbdo.dataType() == "int") {
                    endminutePN = fbdo.intData();
                  }
                }

                if (hour == starthourPN) {
                  if (minute > startminutePN) {
                    checkstartminute = true;
                  } else {
                    checkstartminute = false;
                  }
                } else {
                  checkstartminute = true;
                }

                if (hour == endhourPN) {
                  if (minute < endminutePN) {
                    checkendminute = true;
                  } else {
                    checkendminute = false;
                  }
                } else {
                  checkendminute = true;
                }



                //if(((hour>starthourPN)&&(checkstartminute = true)) && ((hour<endhourPN)&&(checkendminute = true)))
                if ((hour > starthourPN || (hour == starthourPN && minute >= startminutePN)) && (hour < endhourPN || (hour == endhourPN && minute <= endminutePN))) {

                  if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/temperature")) {
                    if (fbdo.dataType() == "int") {
                      settemperaturesalon = fbdo.intData();
                    } else {
                      Serial.println("FAILED READ DATA OF LED FROM REALTIME DATABASE");
                    }
                  }
                }
              }
            }
          }


          przerwania();
          getopenlevel();
          databasesalonlightstearing();     // sterowanie swiatlem w salonie z poziomu aplikacji mobilnej
          databasebathroomlightstearing();  // sterowanie swiatlem w łazience z poziomu aplikacji mobilnej
          databasekitchenlightstearing();


          if (Firebase.RTDB.getBool(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/sr")) {  //sprawdza czy zasada wytepuje w czwartek
            if (fbdo.dataType() == "boolean") {
              bool sr = fbdo.boolData();
              if (sr == true && dayOfWeekIndex == 3) {

                int starthourPN;
                int startminutePN;
                int endhourPN;
                int endminutePN;
                bool checkstartminute;
                bool checkendminute;

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/start_time_hour")) {
                  if (fbdo.dataType() == "int") {
                    starthourPN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/start_time_minute")) {
                  if (fbdo.dataType() == "int") {
                    startminutePN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/end_time_hour")) {
                  if (fbdo.dataType() == "int") {
                    endhourPN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/end_time_minute")) {
                  if (fbdo.dataType() == "int") {
                    endminutePN = fbdo.intData();
                  }
                }

                if (hour == starthourPN) {
                  if (minute > startminutePN) {
                    checkstartminute = true;
                  } else {
                    checkstartminute = false;
                  }
                } else {
                  checkstartminute = true;
                }

                if (hour == endhourPN) {
                  if (minute < endminutePN) {
                    checkendminute = true;
                  } else {
                    checkendminute = false;
                  }
                } else {
                  checkendminute = true;
                }



                //if(((hour>starthourPN)&&(checkstartminute = true)) && ((hour<endhourPN)&&(checkendminute = true)))
                if ((hour > starthourPN || (hour == starthourPN && minute >= startminutePN)) && (hour < endhourPN || (hour == endhourPN && minute <= endminutePN))) {

                  if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/temperature")) {
                    if (fbdo.dataType() == "int") {
                      settemperaturesalon = fbdo.intData();
                    } else {
                      Serial.println("FAILED READ DATA OF LED FROM REALTIME DATABASE");
                    }
                  }
                }
              }
            }
          }


          przerwania();
          getopenlevel();
          databasesalonlightstearing();     // sterowanie swiatlem w salonie z poziomu aplikacji mobilnej
          databasebathroomlightstearing();  // sterowanie swiatlem w łazience z poziomu aplikacji mobilnej
          databasekitchenlightstearing();

          if (Firebase.RTDB.getBool(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/cz")) {  //sprawdza czy zasada wytepuje w czwartek
            if (fbdo.dataType() == "boolean") {
              bool cz = fbdo.boolData();
              if (cz == true && dayOfWeekIndex == 4) {

                int starthourPN;
                int startminutePN;
                int endhourPN;
                int endminutePN;
                bool checkstartminute;
                bool checkendminute;

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/start_time_hour")) {
                  if (fbdo.dataType() == "int") {
                    starthourPN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/start_time_minute")) {
                  if (fbdo.dataType() == "int") {
                    startminutePN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/end_time_hour")) {
                  if (fbdo.dataType() == "int") {
                    endhourPN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/end_time_minute")) {
                  if (fbdo.dataType() == "int") {
                    endminutePN = fbdo.intData();
                  }
                }

                if (hour == starthourPN) {
                  if (minute > startminutePN) {
                    checkstartminute = true;
                  } else {
                    checkstartminute = false;
                  }
                } else {
                  checkstartminute = true;
                }

                if (hour == endhourPN) {
                  if (minute < endminutePN) {
                    checkendminute = true;
                  } else {
                    checkendminute = false;
                  }
                } else {
                  checkendminute = true;
                }



                //if(((hour>starthourPN)&&(checkstartminute = true)) && ((hour<endhourPN)&&(checkendminute = true)))
                if ((hour > starthourPN || (hour == starthourPN && minute >= startminutePN)) && (hour < endhourPN || (hour == endhourPN && minute <= endminutePN))) {

                  if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/temperature")) {
                    if (fbdo.dataType() == "int") {
                      settemperaturesalon = fbdo.intData();
                    } else {
                      Serial.println("FAILED READ DATA OF LED FROM REALTIME DATABASE");
                    }
                  }
                }
              }
            }
          }


          przerwania();
          getopenlevel();
          databasesalonlightstearing();     // sterowanie swiatlem w salonie z poziomu aplikacji mobilnej
          databasebathroomlightstearing();  // sterowanie swiatlem w łazience z poziomu aplikacji mobilnej
          databasekitchenlightstearing();



          if (Firebase.RTDB.getBool(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/pt")) {  //sprawdza czy zasada wytepuje w czwartek
            if (fbdo.dataType() == "boolean") {
              bool pt = fbdo.boolData();
              if (pt == true && dayOfWeekIndex == 5) {

                int starthourPN;
                int startminutePN;
                int endhourPN;
                int endminutePN;
                bool checkstartminute;
                bool checkendminute;

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/start_time_hour")) {
                  if (fbdo.dataType() == "int") {
                    starthourPN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/start_time_minute")) {
                  if (fbdo.dataType() == "int") {
                    startminutePN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/end_time_hour")) {
                  if (fbdo.dataType() == "int") {
                    endhourPN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/end_time_minute")) {
                  if (fbdo.dataType() == "int") {
                    endminutePN = fbdo.intData();
                  }
                }

                if (hour == starthourPN) {
                  if (minute > startminutePN) {
                    checkstartminute = true;
                  } else {
                    checkstartminute = false;
                  }
                } else {
                  checkstartminute = true;
                }

                if (hour == endhourPN) {
                  if (minute < endminutePN) {
                    checkendminute = true;
                  } else {
                    checkendminute = false;
                  }
                } else {
                  checkendminute = true;
                }



                //if(((hour>starthourPN)&&(checkstartminute = true)) && ((hour<endhourPN)&&(checkendminute = true)))
                if ((hour > starthourPN || (hour == starthourPN && minute >= startminutePN)) && (hour < endhourPN || (hour == endhourPN && minute <= endminutePN))) {

                  if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/temperature")) {
                    if (fbdo.dataType() == "int") {
                      settemperaturesalon = fbdo.intData();
                    } else {
                      Serial.println("FAILED READ DATA OF LED FROM REALTIME DATABASE");
                    }
                  }
                }
              }
            }
          }


          przerwania();
          getopenlevel();
          databasesalonlightstearing();     // sterowanie swiatlem w salonie z poziomu aplikacji mobilnej
          databasebathroomlightstearing();  // sterowanie swiatlem w łazience z poziomu aplikacji mobilnej
          databasekitchenlightstearing();



          if (Firebase.RTDB.getBool(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/so")) {  //sprawdza czy zasada wytepuje w czwartek
            if (fbdo.dataType() == "boolean") {
              bool so = fbdo.boolData();
              if (so == true && dayOfWeekIndex == 6) {

                int starthourPN;
                int startminutePN;
                int endhourPN;
                int endminutePN;
                bool checkstartminute;
                bool checkendminute;

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/start_time_hour")) {
                  if (fbdo.dataType() == "int") {
                    starthourPN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/start_time_minute")) {
                  if (fbdo.dataType() == "int") {
                    startminutePN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/end_time_hour")) {
                  if (fbdo.dataType() == "int") {
                    endhourPN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/end_time_minute")) {
                  if (fbdo.dataType() == "int") {
                    endminutePN = fbdo.intData();
                  }
                }

                if (hour == starthourPN) {
                  if (minute > startminutePN) {
                    checkstartminute = true;
                  } else {
                    checkstartminute = false;
                  }
                } else {
                  checkstartminute = true;
                }

                if (hour == endhourPN) {
                  if (minute < endminutePN) {
                    checkendminute = true;
                  } else {
                    checkendminute = false;
                  }
                } else {
                  checkendminute = true;
                }



                //if(((hour>starthourPN)&&(checkstartminute = true)) && ((hour<endhourPN)&&(checkendminute = true)))
                if ((hour > starthourPN || (hour == starthourPN && minute >= startminutePN)) && (hour < endhourPN || (hour == endhourPN && minute <= endminutePN))) {

                  if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/temperature")) {
                    if (fbdo.dataType() == "int") {
                      settemperaturesalon = fbdo.intData();
                    } else {
                      Serial.println("FAILED READ DATA OF LED FROM REALTIME DATABASE");
                    }
                  }
                }
              }
            }
          }

          przerwania();
          getopenlevel();
          databasesalonlightstearing();     // sterowanie swiatlem w salonie z poziomu aplikacji mobilnej
          databasebathroomlightstearing();  // sterowanie swiatlem w łazience z poziomu aplikacji mobilnej
          databasekitchenlightstearing();



          if (Firebase.RTDB.getBool(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/nd")) {  //sprawdza czy zasada wytepuje w czwartek
            if (fbdo.dataType() == "boolean") {
              bool nd = fbdo.boolData();
              if (nd == true && dayOfWeekIndex == 0) {

                int starthourPN;
                int startminutePN;
                int endhourPN;
                int endminutePN;
                bool checkstartminute;
                bool checkendminute;

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/start_time_hour")) {
                  if (fbdo.dataType() == "int") {
                    starthourPN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/start_time_minute")) {
                  if (fbdo.dataType() == "int") {
                    startminutePN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/end_time_hour")) {
                  if (fbdo.dataType() == "int") {
                    endhourPN = fbdo.intData();
                  }
                }

                if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/end_time_minute")) {
                  if (fbdo.dataType() == "int") {
                    endminutePN = fbdo.intData();
                  }
                }

                if (hour == starthourPN) {
                  if (minute > startminutePN) {
                    checkstartminute = true;
                  } else {
                    checkstartminute = false;
                  }
                } else {
                  checkstartminute = true;
                }

                if (hour == endhourPN) {
                  if (minute < endminutePN) {
                    checkendminute = true;
                  } else {
                    checkendminute = false;
                  }
                } else {
                  checkendminute = true;
                }



                //if(((hour>starthourPN)&&(checkstartminute = true)) && ((hour<endhourPN)&&(checkendminute = true)))
                if ((hour > starthourPN || (hour == starthourPN && minute >= startminutePN)) && (hour < endhourPN || (hour == endhourPN && minute <= endminutePN))) {

                  if (Firebase.RTDB.getInt(&fbdo, "/Grzejnik1/Zasada" + String(i) + "/temperature")) {
                    if (fbdo.dataType() == "int") {
                      settemperaturesalon = fbdo.intData();
                    } else {
                      Serial.println("FAILED READ DATA OF LED FROM REALTIME DATABASE");
                    }
                  }
                }
              }
            }
          }



          //na chwile
        }
        if (delete1 == true) {
          //Serial.println("nic nie robie bo ta zasada tak naprawde nie istnieje");
        }
      }
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // logika wyżej decyduje jakie wartości przypisac do zmiennej settemperaturesalon w zaleznosci od parametrow z bazy danych
  // Regulator dwustanowy
  // regulacja dwustanowa: od ustawionej temperatury jesli o 1 wiekszy wyłącz grzanie
  // od ustawionej temperatury jeśli o jeden mniejszy włącz ogrzewanie

  if (temperaturasalon < (settemperaturesalon - 0.06)) {

    digitalWrite(ledPin5, true);
    grzaniestate = true;
  }
  if (temperaturasalon > (settemperaturesalon + 0.06)) {
    digitalWrite(ledPin5, false);
    grzaniestate = false;
  }
}


void printLocalTime() {

  struct tm timeinfo;
  if (!getLocalTime(&timeinfo)) {
    Serial.println("Failed to obtain time");
    return;
  }

  dayOfWeekIndex = timeinfo.tm_wday;
  hour = timeinfo.tm_hour;
  minute = timeinfo.tm_min;
}


void grzalka() {

  //Wysylanie informacji o temperaturze
  if (Firebase.RTDB.setBool(&fbdo, "/Salon/grzalka", grzaniestate)) {
  } else {
    Serial.println("error" + fbdo.errorReason());
  }
}

void motiondetected() {
  // po przerwaniu po wykryciu
  //aktywacja alarmu w przypdaku wykrycia ruchu
  //dodac warunek wlaczenia alarmu z aplikacji mobilnej
  //dodac wyslanie informacji o alarmie do bazy danych
  if (alarmturnedON) {
    digitalWrite(ledPin12, true);
    alarm1 = true;
    startTimer = true;
    lastTrigger = millis();
    if (Firebase.RTDB.setBool(&fbdo, "/Salon/alarm", alarm1)) {
    } else {
      Serial.println("error" + fbdo.errorReason());
    }
  }
}

void deactivatealarm() {  //zatrzymuje dzwiek alarmu po 15 sekundach

  actualTime = millis();
  if (startTimer && (actualTime - lastTrigger > 15000)) {
    digitalWrite(ledPin12, false);
    startTimer = false;
    alarm1 = false;
    if (Firebase.RTDB.setBool(&fbdo, "/Salon/alarm", alarm1)) {
    } else {
      Serial.println("error" + fbdo.errorReason());
    }
  }
}

void getinformationabputsecurity() {  // sprawdza czy użytkownik zdeklarował włączenie alarmu, zamknięcie rolet w 100% itd.
  if (Firebase.RTDB.getBool(&fbdo, "/Salon/alarmOn")) {
    if (fbdo.dataType() == "boolean") {
      alarmturnedON = fbdo.boolData();
    } else {
      Serial.println("FAILED READ DATA OF LED FROM REALTIME DATABASE");
    }
  }
}



void sendopenlevel() {

  if (isButtonHeld11 == false && isButtonHeld22 == false) {
    currentPosition = servo.read();

    if (currentPosition < 0) {
      currentPosition = 0;
    }
    if (currentPosition > 177) {
      currentPosition = 180;
    }


    if (Firebase.RTDB.setInt(&fbdo, "/Salon/openlevel", currentPosition)) {

    } else {

      Serial.println("error" + fbdo.errorReason());
    }
  }
}



void getopenlevel() {
  int setopenlevel;
  if (isButtonHeld11 == false && isButtonHeld22 == false) {
    if (Firebase.RTDB.getInt(&fbdo, "/Salon/openlevel")) {

      if (fbdo.dataType() == "int") {
        setopenlevel = fbdo.intData();
        // servo.write(setopenlevel);
        // std::lock_guard<std::mutex> lock(mtx);
        //currentAngle = setopenlevel;
        // Płynne wygładzanie ruchu
        std::lock_guard<std::mutex> lock(mtx);
        int targetAngle = setopenlevel;
        currentAngle = servo.read();
        int step = 1;        // Ilość kroków do wykonania w jednej iteracji
        int delayTime = 20;  // Opóźnienie między iteracjami (może być dostosowane)

        while (currentAngle != targetAngle) {
          if (currentAngle < targetAngle) {
            currentAngle += step;
            if (currentAngle > targetAngle) {
              currentAngle = targetAngle;
            }
          } else {
            currentAngle -= step;
            if (currentAngle < targetAngle) {
              currentAngle = targetAngle;
            }
          }

          servo.write(currentAngle);
          delay(delayTime);
        }
        currentAngle = setopenlevel;




        //current angle jest wykorzystywaną zmienną globalną w wątku ręcznego sterowania roletą
      } else {
        Serial.println("FAILED READ DATA OF LED FROM REALTIME DATABASE");
      }
    }
  }
}

void przerwania() {
  if (buttonPressed19) {  // przerwanie z włącznika światła w salonie
    buttonPressed19 = false;
    salonlightstearing();  // sterowanie swiatlem w salonie z poziomu domu
  }
  if (buttonPressed23) {  // przerwanie z włącznika światła w kuchni
    buttonPressed23 = false;
    kitchenlightstearing();  // sterowanie swiatlem w kuchni z poziomu domu
  }
  if (buttonPressed13) {  // przerwanie z włącznika światła w łazience
    buttonPressed13 = false;
    bathroomlightstearing();  // sterowanie swiatlem w łazience z poziomu domu
  }
  if (motionDetected14) {  // przerwanie z czujnika ruchu
    motionDetected14 = false;
    motiondetected();  // wykrywanie ruchu przez czujnik i wysyłka do bazy realtime database
  }
  if (buttonPressed27) {
    buttonPressed27 = false;
    sendopenlevel();
  }
  if (buttonPressed26) {
    buttonPressed26 = false;
    sendopenlevel();
  }
}






/////// PONIZSZE PETLE REALIZOWANE SA W RAMACH INNEGO WATKU NIZ TE POWYZEJ


void servoControlTask(void* pvParameters) {  // pętla innego wątku



  while (true) {




    if (isButtonHeld) {
      jazdawdol();
    }

    if (isButtonHeld2) {
      jazdawgore();
    }
  }
}



void jazdawgore() {
  // xSemaphoreTake(mutex, portMAX_DELAY);
  //currentAngle = servo.read();
  std::lock_guard<std::mutex> lock(mtx);

  currentAngle += servoSpeed;
  if (currentAngle > 180) {
    currentAngle = 180;
  }


  if (isButtonHeld2 == false) {
    return;
  }
  servo.write(currentAngle);
  delay(20);
}

void jazdawdol() {
  // xSemaphoreTake(mutex, portMAX_DELAY);
  std::lock_guard<std::mutex> lock(mtx);

  currentAngle -= servoSpeed;
  if (currentAngle < 0) {
    currentAngle = 0;
  }
  if (isButtonHeld == false) {
    return;
  }
  servo.write(currentAngle);
  delay(20);
}
