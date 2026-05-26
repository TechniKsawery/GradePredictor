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
*   [`lib/providers/`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/providers/) – Zarządzanie stanem Riverpod (oceny, przedmioty, ustawienia, motyw, lokalizacja).
*   [`lib/services/`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/services/) – Warstwa integracji i usług:
    *   [`supabase_service.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/services/supabase_service.dart) – Operacje CRUD na bazie Supabase.
    *   [`school_integration_service.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/services/school_integration_service.dart) – Klient integracji z dziennikiem Librus/Vulcan.
    *   [`gemini_parser_service.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/services/gemini_parser_service.dart) – Integracja z Gemini API do analizy i normalizacji ocen.
    *   [`google_calendar_service.dart`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/services/google_calendar_service.dart) – Synchronizacja z Kalendarzem Google.
*   [`lib/screens/`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/screens/) – Ekrany widoków aplikacji (Home, Stats, Calendar, School Sync, Subject Details, Settings, Login).
*   [`lib/widgets/`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/widgets/) – Reużywalne komponenty UI (karty ocen, dialogi, formularze).
*   [`lib/l10n/`](file:///c:/Users/KsaweryBloch/PAM/Projekt%20na%20koniec%20roku/lib/l10n/) – Pliki tłumaczeń lokalizacyjnych (`app_pl.arb`, `app_en.arb`, `app_de.arb`).

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