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

Na poniższym zrzucie ekranu przedstawiono listę zasad dodanych już przez użytkownika oraz możliwość ich usunięcie.

![usuwanie zasad](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/e8bf4800-5c4d-46f1-b262-dd0e900a7ba8)


### 2. Baza danych - Realtime Database
W udostępnionym projekcie wykorzystana została baza danych Realtime Database. Plikiem koniecznym do działania kodu aplikacji jest plik firebase_options zawierający adres serwera oraz klucze API (w celu zapewnienia bezpieczeństwa danych nie zostały one udostępnione). Poniżej przedstawione więc zostały struktury w bazie danych odpowiedzialne kolejno za sterowanie ręczne (/Salon) i przechowywanie zasad autoamtycznego ogrzewania (/Grzejnik1) na podstawie których można utworzyć identyczną bazę danych.

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

![schemat 2 dla PCB](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/a0d36acd-3d50-4ed4-afb6-759d4ecf8867)

Utworzony został również obwód drukowany widoczny na zdjęciu wykonanego prototypu:

![układ](https://github.com/stanislawszewerda/SmartHome---Just-For-You/assets/111526111/606ad94b-b42d-4f86-a211-df2f2bb9ccfc)



