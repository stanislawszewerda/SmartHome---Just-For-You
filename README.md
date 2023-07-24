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

hasło: test_aplikacji

#### 1.1 Ekran Logowania
Ekran logowania umożliwia zalogowanie się za pomocą adresu email oraz hasła. 
Pełny dostęp do bazy danych i poprawne działanie aplikacji zapewnia tylko zalogowanie się 
danymi przedstawionymi powyżej.

![logowanie](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/7a28fe77-9eaf-41c2-9211-8c31973a8945)

#### 1.2 Ekran Główny
Ekran główny w obecnej wersji umożliwia przejście do interfejsu Automatycznego Ogrzewania oraz Sterowania Ręcznego (zaznaczone na czerwono)

![ekranglowny](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/870468eb-b494-4118-8a0a-d01fa9040f43)

#### 1.3 Sterowanie Ręczne
Ekran sterowania ręcznego umożliwia włączanie i wyłączanie świateł w kolejnych pomieszczeniach, włączenie alarmu, sterowanie roletą, odczytanie temperatury, stanu pracy alarmu oraz grzejnika

![recznesterowanie](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/608ba090-f017-4663-8d9d-73a8bb542208)

#### 1.4 Automatyczne Ogrzewanie
Ekran ogrzewania automatycznego umożliwia użytkownikowi dodawanie zasad ogrzewania (tj. temperatury utrzymywanej w domu w odpowiednich godzinach w odpowiednie dni tygodnia). Intefejs dodawania zasady przedstawiono na poniższym zdjęciu

![zasady](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/1b1c4076-c213-4032-b7f9-3ecc0116c954)

Na poniższym zrzucie ekranu przedstawiono listę zasad dodanych już przez użytkownika oraz możliwość ich usunięcia.

![usuwanie zasad](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/e8bf4800-5c4d-46f1-b262-dd0e900a7ba8)


### 2. Baza danych - Realtime Database
W udostępnionym projekcie wykorzystana została baza danych Realtime Database. Plikiem koniecznym do działania kodu aplikacji jest plik firebase_options zawierający adres serwera oraz klucze API (w celu zapewnienia bezpieczeństwa danych nie zostały one udostępnione). Poniżej przedstawione więc zostały struktury w bazie danych odpowiedzialne kolejno za sterowanie ręczne (/Salon) i przechowywanie zasad automatycznego ogrzewania (/Grzejnik1) na podstawie których można utworzyć identyczną bazę danych.

![struktura1](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/b3e29ae2-05d7-4702-9b28-3a97ef80305e)

![salon](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/5acdf1b7-0822-48b0-bbb2-f0fed07570db)

![Grzejnik1](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/60945b42-36d0-4e59-abe4-67bd02505b29)

Każda z kolejnych struktur od zasada1 do zasada10 zawiera taką samą strukturę przedstawioną poniżej. Wartość "id" jest równa numerowi zasady.

![Zasada1](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/92162234-e442-4cec-bee1-3e85dd7c3de3)

### 3. Układ prototypowy inteligentnego domu (moduł ESP 32)

![PLAN DOMU 3](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/4b5b0bfd-417d-42e6-b296-5ab6871f830b)

Moduł ESP 32 zaprogramowany został z wykorzystaniem środowiska Arduino IDE. 
Kod programu znaleźć można w pliku ESP CODE tego repozytorium

W ramach projektu utworzony został układ prototypowy utworzony zgodnie z przedstawionym poniżej schematem elektrycznym. 

![schemat](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/a7486260-c403-45fb-b270-52406d0d755c)

Utworzony został również obwód drukowany widoczny na zdjęciu wykonanego prototypu:

![układ](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/606ad94b-b42d-4f86-a211-df2f2bb9ccfc)

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

password: test_application

#### 1.1 Login Screen
The login screen allows you to log in with your email address and password. 
Full access to the database and correct operation of the application is ensured only by logging in with the 
with the data shown above.

![logowanie](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/7a28fe77-9eaf-41c2-9211-8c31973a8945)

#### 1.2 Home Screen
The main screen in the current version allows you to go to the Automatic Heating and Manual Control interface (highlighted in red).

![ekranglowny](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/870468eb-b494-4118-8a0a-d01fa9040f43)

#### 1.3 Manual Control
The Manual Control screen allows you to turn on and off the lights in the following rooms, turn on the alarm, control the roller shutter, read the temperature, alarm operating status and the heater

![recznesterowanie](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/608ba090-f017-4663-8d9d-73a8bb542208)

#### 1.4 Automatic Heating
The Automatic Heating screen allows the user to add heating rules (i.e., the temperature maintained in the house at appropriate times on appropriate days of the week). The interface for adding a rule is shown in the following picture.

![zasady](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/1b1c4076-c213-4032-b7f9-3ecc0116c954)

The following screenshot shows the list of rules already added by the user and the possibility to delete them.

![usuwanie zasad](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/e8bf4800-5c4d-46f1-b262-dd0e900a7ba8)


### 2. Database - Realtime Database
The Realtime Database is used in the project provided. The file necessary for the application code to work is the firebase_options file containing the server address and API keys (to ensure the security of the data, they have not been shared). Thus, the following are the structures in the database responsible, in turn, for manual control (/Salon) and storage of automatic heating rules (/Heater1) based on which an identical database can be created.

![struktura1](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/b3e29ae2-05d7-4702-9b28-3a97ef80305e)

![salon](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/5acdf1b7-0822-48b0-bbb2-f0fed07570db)

![Grzejnik1](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/60945b42-36d0-4e59-abe4-67bd02505b29)

Each of the following structures from rule1 to rule10 contains the same structure shown below. The "id" value is equal to the rule number.

![Zasada1](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/92162234-e442-4cec-bee1-3e85dd7c3de3)

### 3. prototype layout of the smart home (ESP 32 module).

![PLAN DOMU 3](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/4b5b0bfd-417d-42e6-b296-5ab6871f830b)

The ESP 32 module was programmed using the Arduino IDE environment. 
The program code can be found in the ESP CODE file of this repository

The project included a prototype circuit created according to the electrical schematic shown below. 

![schemat](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/a7486260-c403-45fb-b270-52406d0d755c)

The printed circuit shown in the photo of the completed prototype was also created:

![układ](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/606ad94b-b42d-4f86-a211-df2f2bb9ccfc)

In the picture shown above, the following components are detailed: ESP 32 module(1); yellow LEDs representing light operation in the living room(2), kitchen(3) and bathroom(4); red LED representing heating operation(5); blue LED representing alarm operation(6); monostable buttons representing light switching in the living room(7), kitchen(8) and bathroom(9); monostable buttons representing the button for raising(10) and lowering(11) the roller shutter; servomotor representing the roller shutter(12); motion sensor(13); temperature sensor(14); heating resistor representing the heater(15); relay(16); piezo transducer representing the alarm siren(17)
