# GradePredictor

Aplikacja Flutter do zarządzania ocenami, przedmiotami, egzaminami i prognozami wyników.
Projekt korzysta z Riverpod, Supabase, lokalizacji językowych oraz integracji ze szkołami typu Librus i Vulcan.

## Funkcje

- logowanie i synchronizacja danych użytkownika
- lista przedmiotów, ocen i egzaminów
- statystyki oraz średnie z przedmiotów
- prognozowanie ocen
- kalendarz terminów
- synchronizacja z systemami szkolnymi
- przełączanie języka: polski, angielski, niemiecki
- jasny i ciemny motyw

## Stack

- Flutter
- Riverpod
- Supabase
- fl_chart
- intl
- google_fonts
- shared_preferences

## Uruchomienie

Zainstaluj zależności:

```bash
flutter pub get
```

Uruchom aplikację na wybranym urządzeniu:

```bash
flutter run
```

Jeśli chcesz uruchomić aplikację na konkretnym emulatorze, podaj jego identyfikator, na przykład:

```bash
flutter run -d emulator-5554
```

## Struktura projektu

- `lib/main.dart` - wejście aplikacji i konfiguracja motywu oraz lokalizacji
- `lib/screens/` - ekrany aplikacji
- `lib/providers/` - stan aplikacji i logika Riverpod
- `lib/services/` - integracje z Supabase i systemami szkolnymi
- `lib/widgets/` - współdzielone komponenty UI
- `lib/l10n/` - tłumaczenia aplikacji

## Uwagi

Projekt jest przygotowany jako aplikacja prywatna i nie jest publikowany na pub.dev.
