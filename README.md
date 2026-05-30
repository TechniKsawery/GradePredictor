# GradePredictor ✨

> Aplikacja mobilna Flutter stworzona z myślą o uczniach, ułatwiająca zarządzanie ocenami, śledzenie sprawdzianów i prognozowanie średnich ocen przy pomocy zaawansowanej analizy oraz sztucznej inteligencji.

---

## 🌟 Kluczowe Funkcje

*   **Pulpit (Home Screen):**
    *   Podgląd bieżących ocen i średnich ze wszystkich przedmiotów.
    *   Szybkie dodawanie/edycja przedmiotów, ocen (tradycyjnych oraz punktowych) i zaplanowanych sprawdzianów.
    *   Inteligentny system prognozowania średniej na podstawie dodawanych ocen "symulowanych".
*   **Wizualne Statystyki (Stats Screen):**
    *   Wykresy kołowe i liniowe prezentujące rozkład ocen oraz trendy średnich z wykorzystaniem biblioteki `fl_chart`.
    *   Szczegółowe zestawienia średnich ważonych i arytmetycznych.
*   **Terminarz i Kalendarz (Calendar Screen):**
    *   Przejrzysty widok miesięczny i tygodniowy z zaplanowanymi sprawdzianami, kartkówkami i zadaniami domowymi.
    *   Dwukierunkowa integracja z **Google Calendar** w celu synchronizacji terminów szkolnych z osobistym kalendarzem.
*   **Synchronizacja z Dziennikami Szkolnymi (School Sync):**
    *   Bezpośrednie pobieranie danych (ocen, tematów lekcji, zadań domowych, sprawdzianów) z systemów **Librus** i **Vulcan**.
    *   Możliwość konfiguracji automatycznej synchronizacji w tle.
*   **Inteligentne Parsowanie Ocen (Gemini AI):**
    *   Wykorzystanie modelu **Gemini AI** (`gemini-1.5-flash`) do analizy niestandardowych wpisów w dziennikach (np. klasyfikacja ocen punktowych "12/15", interpretacja komentarzy nauczycieli, wyliczanie wag).
    *   Wsparcie dla wywołań bezpośrednich (Client-Side) oraz za pośrednictwem bezpiecznych **Supabase Edge Functions**.
*   **Personalizacja (Settings):**
    *   Obsługa motywu jasnego oraz ciemnego (dopasowanego do preferencji systemowych).
    *   Pełna lokalizacja językowa (języki: **polski**, **angielski**, **niemiecki**).

---

## 🛠️ Stos Technologiczny

*   **Framework:** [Flutter](https://flutter.dev/) (SDK: `^3.11.4`)
*   **Zarządzanie Stanem:** [Flutter Riverpod](https://pub.dev/packages/flutter_riverpod)
*   **Baza Danych & Autoryzacja:** [Supabase](https://supabase.com/) (`supabase_flutter`)
*   **Sztuczna Inteligencja:** [Gemini API](https://ai.google.dev/) (model `gemini-1.5-flash`)
*   **Wykresy:** [fl_chart](https://pub.dev/packages/fl_chart)
*   **Lokalizacja:** `flutter_localizations` oraz generator klas tłumaczeń z plików `.arb`
*   **Przechowywanie Danych Lokalnych:** `shared_preferences`

---

## 🧩 Architektura Projektu

Struktura katalogów wewnątrz `lib/`:

*   [`lib/main.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/main.dart) – Punkt wejściowy aplikacji, inicjalizacja Supabase oraz ładowanie konfiguracji środowiskowej.
*   [`lib/models/`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/models/) – Definicje modeli danych:
    *   [`exam.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/models/exam.dart) – Model sprawdzianów/zadań.
    *   [`grade.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/models/grade.dart) – Model pojedynczej oceny (wartość, waga, punkty).
    *   [`subject.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/models/subject.dart) – Model przedmiotu i konfiguracji skali oceniania.
    *   [`profile.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/models/profile.dart) – Informacje o koncie użytkownika.
*   [`lib/providers/`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/providers/) – Zarządzanie stanem Riverpod:
    *   [`accounts_provider.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/providers/accounts_provider.dart) – Zarządzanie kontami zewnętrznych dzienników.
    *   [`grade_provider.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/providers/grade_provider.dart) – Stan ocen, sprawdzianów i przedmiotów.
    *   [`locale_provider.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/providers/locale_provider.dart) – Obsługa lokalizacji i języka aplikacji.
    *   [`profile_provider.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/providers/profile_provider.dart) – Informacje o profilu zalogowanego użytkownika.
    *   [`settings_provider.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/providers/settings_provider.dart) – Zarządzanie ustawieniami aplikacji.
    *   [`theme_provider.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/providers/theme_provider.dart) – Zarządzanie motywem graficznym (jasny/ciemny).
*   [`lib/services/`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/services/) – Warstwa integracji i usług:
    *   [`supabase_service.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/services/supabase_service.dart) – Operacje CRUD na bazie Supabase.
    *   [`school_integration_service.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/services/school_integration_service.dart) – Klient integracji z dziennikiem Librus/Vulcan.
    *   [`auto_sync_service.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/services/auto_sync_service.dart) – Automatyczna synchronizacja ocen i sprawdzianów w tle.
    *   [`school_extraction_service.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/services/school_extraction_service.dart) – Lokalna ekstrakcja szczegółów ocen (punkty, wagi, typy).
    *   [`gemini_parser_service.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/services/gemini_parser_service.dart) – Integracja z Gemini API do inteligentnej analizy ocen.
    *   [`google_calendar_service.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/services/google_calendar_service.dart) – Dwukierunkowa synchronizacja z Kalendarzem Google.
*   [`lib/screens/`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/screens/) – Ekrany aplikacji:
    *   [`home_screen.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/screens/home_screen.dart) – Panel główny z ocenami, średnimi i opcją symulacji.
    *   [`stats_screen.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/screens/stats_screen.dart) – Wizualizacja rozkładu ocen i trendów za pomocą wykresów.
    *   [`calendar_screen.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/screens/calendar_screen.dart) – Widok kalendarza ze sprawdzianami i zadaniami.
    *   [`school_sync_screen.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/screens/school_sync_screen.dart) – Konfiguracja i logowanie do e-dziennika Librus/Vulcan.
    *   [`subject_detail_screen.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/screens/subject_detail_screen.dart) – Detale przedmiotu, edycja i dodawanie ocen.
    *   [`settings_screen.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/screens/settings_screen.dart) – Konfiguracja motywu, języka oraz konta.
    *   [`login_screen.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/screens/login_screen.dart) – Logowanie i rejestracja do konta GradePredictor (Supabase).
*   [`lib/widgets/`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/widgets/) – Reużywalne komponenty interfejsu:
    *   [`prediction_dialog.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/widgets/prediction_dialog.dart) – Dialog symulacji ocen i prognozowania średniej.
    *   [`translated_text.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/widgets/translated_text.dart) – Komponent obsługujący automatyczne lub predefiniowane tłumaczenia.
*   [`lib/utils/`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/utils/) – Klasy pomocnicze:
    *   [`date_formatter.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/utils/date_formatter.dart) – Pomocnicze funkcje formatowania dat.
    *   [`grade_converter.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/utils/grade_converter.dart) – Konwersja i normalizacja ocen szkolnych.
    *   [`subject_translator.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/utils/subject_translator.dart) – Słowniki tłumaczenia i ujednolicania nazw przedmiotów.
*   [`lib/l10n/`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/l10n/) – Pliki lokalizacyjne dla systemu wielojęzyczności (`app_pl.arb`, `app_en.arb`, `app_de.arb`).

---

## 🚀 Przygotowanie do Uruchomienia

### 1. Klonowanie i Instalacja Zależności

Pobierz pakiety Flutter:
```bash
flutter pub get
```

### 2. Konfiguracja Środowiska (Zmienne Wrażliwe)

Aplikacja wymaga poprawnej konfiguracji usług zewnętrznych. Wszystkie klucze API są przechowywane w pliku `.env`, który **nigdy nie powinien trafić do systemu kontroli wersji (Git)**.

1. Skopiuj plik szablonu:
   ```bash
   cp .env.example .env
   ```
2. Otwórz plik `.env` i uzupełnij go o własne dane uwierzytelniające:
   ```env
   SUPABASE_URL=https://twoja-instancja.supabase.co
   SUPABASE_ANON_KEY=twoj-publiczny-klucz-anon-supabase
   GEMINI_API_KEY=twoj-prywatny-klucz-gemini-api
   ```

### 3. Konfiguracja Bazy Danych Supabase

Zaimplementuj strukturę tabel, kluczy obcych i polityk bezpieczeństwa (RLS) w swojej bazie Supabase za pomocą edytora SQL w panelu Supabase, uruchamiając zawartość pliku:
*   [`supabase_setup.sql`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/supabase_setup.sql)

### 4. Uruchomienie Projektu

Uruchom aplikację na podłączonym urządzeniu lub emulatorze:
```bash
flutter run
```

---

## 🔒 Bezpieczeństwo i Dane Wrażliwe

*   **Przechowywanie danych:** Dane logowania do systemów Librus/Vulcan są przetwarzane lokalnie i używane wyłącznie w celu nawiązania bezpiecznego połączenia SSL z serwerami dziennika.
*   **Klucze API:** Klucze do Supabase i Gemini API są wstrzykiwane w czasie budowania za pomocą `flutter_dotenv` i nie są hardkodowane w kodzie źródłowym.
*   **Bezpieczeństwo w chmurze:** Tabele Supabase są zabezpieczone politykami Row Level Security (RLS), co gwarantuje, że zalogowani użytkownicy mają dostęp wyłącznie do własnych przedmiotów, ocen i sprawdzianów.