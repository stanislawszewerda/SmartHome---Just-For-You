# PL: SmartHome - Just For You

### Udostępniony projekt został zrealizowany w ramach pracy inżynierskiej!!! 
### Autor: Stanisław Szewerda
### Tytuł: "Aplikacja mobilna do obsługi inteligentnego domu z wykorzystaniem platformy Arduino"
### Uczelnia: Politechnika Opolska

Zrealizowany projekt zawiera Aplikację mobilną umożliwiającą sterowanie inteligentnym domem 
oraz układ prototypowy inteligentnego domu opartego na module ESP 32

### 1. Aplikacja mobilna

Plik instalacyjny .apk aplikacji można pobrać w tym miejscu: tutaj link do dysku google

Aby móc w pełni korzytać z aplikacji należy zalogować się następującymi danymi!!!:

email: test@gmail.com 

hasło: test11

#### 1.1 Ekran Logowania
Ekran logowania umożliwia zalogowanie się za pomocą adresu email oraz hasła. 
Pełny dostęp do bazy danych i poprawne działanie aplikacji zapewnia tylko zalogowanie się 
danymi przedstawionymi powyżej.

![logowanie](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/718d67fb-ce63-4da8-a5ba-28c8b91709fe)

#### 1.2 Ekran Główny
Ekran główny w obecnej wersji umożliwia przejście do interfejsu Automatycznego Ogrzewania oraz Sterowania Ręcznego (zaznaczone na czerwono)

![ekranglowny](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/f6b0df36-921e-4edc-8ffc-bdd6884064ea)


#### 1.3 Sterowanie Ręczne
Ekran sterowania ręcznego umożliwia włączanie i wyłączanie świateł w kolejnych pomieszczeniach, włączenie alarmu, sterowanie roletą, odczytanie temperatury, stanu pracy alarmu oraz grzejnika

![recznesterowanie](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/bac9db67-b42d-458e-ac43-1fbd2e43b2a3)


#### 1.4 Automatyczne Ogrzewanie
Ekran ogrzewania automatycznego umożliwia użytkownikowi dodawanie zasad ogrzewania (tj. temperatury utrzymywanej w domu w odpowiednich godzinach w odpowiednie dni tygodnia). Intefejs dodawania zasady przedstawiono na poniższym zdjęciu

![zasady](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/d6abd247-16b5-4d95-8768-7fe781b89cca)

Na poniższym zrzucie ekranu przedstawiono listę zasad dodanych już przez użytkownika oraz możliwość ich usunięcia.

![usuwanie zasad](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/ab9fcfa8-0f70-42ea-bc5c-1247ee426d2b)

### 2. Baza danych - Realtime Database
W udostępnionym projekcie wykorzystana została baza danych Realtime Database. Plikiem koniecznym do działania kodu aplikacji jest plik firebase_options zawierający adres serwera oraz klucze API (w celu zapewnienia bezpieczeństwa danych nie zostały one udostępnione). Poniżej przedstawione więc zostały struktury w bazie danych odpowiedzialne kolejno za sterowanie ręczne (/Salon) i przechowywanie zasad automatycznego ogrzewania (/Grzejnik1) na podstawie których można utworzyć identyczną bazę danych.

![struktura1](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/500823cc-094e-47bf-b52f-cce1fc87c40a)

![salon](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/667ffbc8-a3c0-4123-b542-71826f37650a)

![Grzejnik1](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/4e0bff85-d4a4-4556-a3a4-c0e01e437663)

Każda z kolejnych struktur od zasada1 do zasada10 zawiera taką samą strukturę przedstawioną poniżej. Wartość "id" jest równa numerowi zasady.

![Zasada1 — kopia](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/9d669890-56ba-4d54-b3e0-b8bf042dc92a)


### 3. Układ prototypowy inteligentnego domu (moduł ESP 32)

![PLAN DOMU 3](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/570fa9c8-d3f2-4bd1-ade2-fbc5c14029c1)

Moduł ESP 32 zaprogramowany został z wykorzystaniem środowiska Arduino IDE. 
Kod programu znaleźć można w pliku ESP CODE tego repozytorium

W ramach projektu utworzony został układ prototypowy utworzony zgodnie z przedstawionym poniżej schematem elektrycznym. 

![schemat](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/c2d47918-f5d7-4a40-b3d7-ccc2f5fd373f)

Utworzony został również obwód drukowany widoczny na zdjęciu wykonanego prototypu:

![układ](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/bafb39c3-9a7f-434f-a2cc-666f48da4110)

Na przedstawionym powyżej zdjęciu zostały wyszczególnione następujące elementy: moduł ESP 32(1); żółte diody LED reprezentujące pracę światła w salonie(2), kuchni(3) i łazience(4); czerwona dioda LED reprezentująca pracę ogrzewania(5); niebieska dioda LED reprezentująca pracę alarmu(6); przyciski monostabilne reprezentujące włączanie światła w salonie(7), kuchni(8) i łazience(9); przyciski monostabilne reprezentujące przycisk podnoszenia(10) i opuszczania(11) rolety; serwomotor reprezentujący roletę(12); czujnik ruchu(13); czujnik temperatury(14); rezystor grzejny reprezentujący grzejnik(15); przekaźnik(16); przetwornik piezoelektryczny reprezentujący syrenę alarmową(17)


# EN: SmartHome - Just For You

### The shared project was done as part of an engineering thesis!!! 
### Author: Stanislaw Szewerda
### Title: "Mobile application to operate a smart home using the Arduino platform".
### University: Opole University of Technology

The completed project includes a Mobile Application to control a smart home 
As well as a prototype arrangement of a smart home based on ESP 32 module

### 1. mobile application

The .apk installation file of the application can be downloaded here: here link to google drive

In order to fully use the application, you must log in with the following credentials!!!:

email: test@gmail.com 

password: test11

#### 1.1 Login Screen
The login screen allows you to log in with your email address and password. 
Full access to the database and correct operation of the application is ensured only by logging in with the 
with the data shown above.

![logowanie](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/c6f75982-57f0-48a9-b8e1-23d44ba38240)


#### 1.2 Home Screen
The main screen in the current version allows you to go to the Automatic Heating and Manual Control interface (highlighted in red).

![ekranglowny](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/8c527626-5c26-4a16-80b4-3efb11c2746c)

#### 1.3 Manual Control
The Manual Control screen allows you to turn on and off the lights in the following rooms, turn on the alarm, control the roller shutter, read the temperature, alarm operating status and the heater

![recznesterowanie](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/29c41b80-e612-4ea1-bbd7-a4ebe02bc5b6)

#### 1.4 Automatic Heating
The Automatic Heating screen allows the user to add heating rules (i.e., the temperature maintained in the house at appropriate times on appropriate days of the week). The interface for adding a rule is shown in the following picture.

![zasady](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/82cec5a9-44cc-4819-ad31-cd0e41cd6a10)

The following screenshot shows the list of rules already added by the user and the possibility to delete them.


![usuwanie zasad](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/67783c8e-5208-49ec-9eec-ccc6f8335d7a)


### 2. Database - Realtime Database
The Realtime Database is used in the project provided. The file necessary for the application code to work is the firebase_options file containing the server address and API keys (to ensure the security of the data, they have not been shared). Thus, the following are the structures in the database responsible, in turn, for manual control (/Salon) and storage of automatic heating rules (/Heater1) based on which an identical database can be created.

![struktura1](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/1b02a2bb-c97f-4777-944b-08f5002fba9b)

![salon](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/337c27e0-f8dd-4acd-90db-c68b59b5bf39)

![Grzejnik1](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/510d57ff-2cd0-4197-8966-993773ae3828)

Each of the following structures from rule1 to rule10 contains the same structure shown below. The "id" value is equal to the rule number.

![Zasada1 — kopia](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/6a08fc36-b282-4c8b-9ebe-9aa335d80d49)

### 3. prototype layout of the smart home (ESP 32 module).

![PLAN DOMU 3](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/1544e56b-46d3-4959-9b4e-cbd579d4d07b)

The ESP 32 module was programmed using the Arduino IDE environment. 
The program code can be found in the ESP CODE file of this repository

The project included a prototype circuit created according to the electrical schematic shown below. 

![schemat](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/4df263fc-6c96-46ed-be6f-73cd9c4c4ad9)


The printed circuit shown in the photo of the completed prototype was also created:

![układ](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/225ae02a-83f5-4a12-87d5-5e04067fbffd)

In the picture shown above, the following components are detailed: ESP 32 module(1); yellow LEDs representing light operation in the living room(2), kitchen(3) and bathroom(4); red LED representing heating operation(5); blue LED representing alarm operation(6); monostable buttons representing light switching in the living room(7), kitchen(8) and bathroom(9); monostable buttons representing the button for raising(10) and lowering(11) the roller shutter; servomotor representing the roller shutter(12); motion sensor(13); temperature sensor(14); heating resistor representing the heater(15); relay(16); piezo transducer representing the alarm siren(17)
